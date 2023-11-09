/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Set up the Workflow
# # Create the Workflows service account
resource "google_service_account" "workflow_service_account" {
  project      = module.project-services.project_id
  account_id   = "cloud-workflow-sa-${random_id.id.hex}"
  display_name = "Service Account for Cloud Workflows"
}

# # Grant the Workflow service account access
resource "google_project_iam_member" "workflow_service_account_roles" {
  for_each = toset([
    "roles/workflows.admin",
    "roles/run.invoker",
    "roles/iam.serviceAccountTokenCreator",
    "roles/storage.objectAdmin",
    "roles/bigquery.connectionUser",
    "roles/bigquery.jobUser",
    "roles/bigquery.dataEditor",
    ]
  )
  project = module.project-services.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.workflow_service_account.email}"
}

# # Create the workflow
resource "google_workflows_workflow" "workflow" {
  name            = "initial-workflow"
  project         = module.project-services.project_id
  region          = var.region
  description     = "Runs post Terraform setup steps for Solution in Console"
  service_account = google_service_account.workflow_service_account.id

  source_contents = templatefile("${path.module}/templates/workflow.tftpl", {
    raw_bucket = google_storage_bucket.raw_bucket.name,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id
  })

  labels = var.labels

  depends_on = [
    google_project_iam_member.workflow_service_account_roles,
  ]
}

data "google_client_config" "current" {
}

# # Trigger the execution of the setup workflow
data "http" "call_workflows_setup" {
  url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow.name}/executions"
  method = "POST"
  request_headers = {
    Accept = "application/json"
  Authorization = "Bearer ${data.google_client_config.current.access_token}" }
  depends_on = [
    google_storage_bucket.raw_bucket,
    google_bigquery_routine.sp_bigqueryml_generate_create,
    google_bigquery_routine.sp_bigqueryml_model,
    google_bigquery_routine.sproc_sp_demo_lookerstudio_report,
    google_bigquery_routine.sp_provision_lookup_tables
  ]
}
