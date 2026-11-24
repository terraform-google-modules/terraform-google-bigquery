locals {
  create_connection = var.connection.create
  connection_ref    = "${var.project_id}.${lower(var.location)}.${var.connection.connection_id}"

  models = { for m in var.models : m.model_id => m }

  model_ddl = {
    for id, m in local.models : id => join("\n", compact([
      "CREATE OR REPLACE MODEL `${var.project_id}.${var.dataset_id}.${id}`",
      "REMOTE WITH CONNECTION `${local.connection_ref}`",
      length(m.options) > 0 ? "OPTIONS (${join(", ", [for k, v in m.options : "${k} = ${v}"])})" : "",
    ]))
  }
}

resource "google_bigquery_connection" "connection" {
  count = local.create_connection ? 1 : 0

  project       = var.project_id
  location      = var.location
  connection_id = var.connection.connection_id
  friendly_name = var.connection.connection_id
  description   = var.connection.description

  cloud_resource {}
}

# The connection service account needs access to Vertex AI to call remote model endpoints.
resource "google_project_iam_member" "connection_sa" {
  for_each = local.create_connection ? toset(var.connection.service_account_roles) : toset([])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_bigquery_connection.connection[0].cloud_resource[0].service_account_id}"
}

# IAM changes are eventually consistent (usually within a minute, sometimes several minutes),
# give them time before creating remote models.
resource "time_sleep" "iam_propagation" {
  count = local.create_connection ? 1 : 0

  create_duration = "180s"
  depends_on      = [google_project_iam_member.connection_sa]
}

# There is no Terraform resource for BigQuery ML models, so they are created by running the
# CREATE OR REPLACE MODEL statement as a BigQuery job. Notes:
# - The job id is derived from the statement, so changing the SQL (or the revision) runs the job again.
# - Destroying this resource does NOT delete the model, use DROP MODEL for that.
# - The provider does not wait for the job result, see model_job_status below.
resource "google_bigquery_job" "create_model" {
  for_each = local.models

  project  = var.project_id
  location = var.location
  job_id   = "tf_create_model_${each.key}_${substr(sha256("${local.model_ddl[each.key]}-${each.value.revision}"), 0, 12)}"

  query {
    query              = local.model_ddl[each.key]
    use_legacy_sql     = false
    create_disposition = ""
    write_disposition  = ""
  }

  depends_on = [time_sleep.iam_propagation]
}

# Give the CREATE MODEL jobs time to finish before checking their result.
resource "time_sleep" "wait_for_model_jobs" {
  for_each = local.models

  create_duration = "30s"
  triggers = {
    job_id = google_bigquery_job.create_model[each.key].job_id
  }
}

data "google_client_config" "current" {}

# The google_bigquery_job resource reports success as soon as the job is started, even when the
# CREATE MODEL statement fails afterwards. Read the real job result and fail when the model was
# not created. This check also runs on every plan, so a failed model stays visible.
data "http" "model_job_status" {
  for_each = local.models

  url = "https://bigquery.googleapis.com/bigquery/v2/projects/${var.project_id}/jobs/${google_bigquery_job.create_model[each.key].job_id}?location=${var.location}"
  request_headers = {
    Authorization = "Bearer ${data.google_client_config.current.access_token}"
  }

  depends_on = [time_sleep.wait_for_model_jobs]

  lifecycle {
    postcondition {
      condition = (
        self.status_code == 200 &&
        try(jsondecode(self.response_body).status.state, "") == "DONE" &&
        try(jsondecode(self.response_body).status.errorResult, null) == null
      )
      error_message = <<-EOT
        BigQuery ML model ${each.key} was not created by job ${google_bigquery_job.create_model[each.key].job_id}:
        ${try(jsondecode(self.response_body).status.errorResult.message, "job state is ${try(jsondecode(self.response_body).status.state, "unknown")} (HTTP ${self.status_code})")}
        Fix the cause, then bump `revision` of the model in terragrunt.hcl to run the CREATE MODEL job again.
      EOT
    }
  }
}
