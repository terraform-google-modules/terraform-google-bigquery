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
## Create the Workflows service account
resource "google_service_account" "workflow_manage_sa" {
  project                      = module.project-services.project_id
  account_id                   = "cloud-workflow-sa-${random_id.id.hex}"
  display_name                 = "Service Account for Cloud Workflows"
  description                  = "Service account used to manage Cloud Workflows"
  create_ignore_already_exists = var.create_ignore_service_accounts


  depends_on = [time_sleep.wait_after_apis]
}

## Define the IAM roles granted to the Workflows service account
locals {
  workflow_roles = [
    "roles/bigquery.connectionUser",
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",
    "roles/run.invoker",
    "roles/storage.objectAdmin",
    "roles/workflows.admin",
  ]
}

## Grant the Workflow service account access
resource "google_project_iam_member" "workflow_manage_sa_roles" {
  count   = length(local.workflow_roles)
  project = module.project-services.project_id
  member  = "serviceAccount:${google_service_account.workflow_manage_sa.email}"
  role    = local.workflow_roles[count.index]

  depends_on = [google_service_account.workflow_manage_sa]
}

## Create the workflow
resource "google_workflows_workflow" "workflow" {
  name            = "initial-workflow"
  project         = module.project-services.project_id
  region          = var.region
  description     = "Runs post Terraform setup steps for Solution in Console"
  service_account = google_service_account.workflow_manage_sa.id

  source_contents = templatefile("${path.module}/templates/workflow.tftpl", {
    raw_bucket    = google_storage_bucket.raw_bucket.name,
    dataset_id    = google_bigquery_dataset.ds_edw.dataset_id,
    function_url  = google_cloudfunctions2_function.notebook_deploy_function.url
    function_name = google_cloudfunctions2_function.notebook_deploy_function.name
  })

  deletion_protection = var.deletion_protection

  labels = var.labels

  depends_on = [
    google_project_iam_member.workflow_manage_sa_roles,
    time_sleep.wait_after_function
  ]
}

module "workflow_polling_1" {
  source               = "./workflow_polling"
  workflow_id          = google_workflows_workflow.workflow.id
  input_workflow_state = null

  depends_on = [
    google_storage_bucket.raw_bucket,
    google_bigquery_routine.sp_bigqueryml_generate_create,
    google_bigquery_routine.sp_bigqueryml_model,
    google_bigquery_routine.sproc_sp_demo_lookerstudio_report,
    google_bigquery_routine.sp_provision_lookup_tables,
    google_workflows_workflow.workflow,
    google_storage_bucket.raw_bucket,
    google_cloudfunctions2_function.notebook_deploy_function,
    time_sleep.wait_after_function,
    google_service_account_iam_member.workflow_auth_function
  ]
}


module "workflow_polling_4" {
  source               = "./workflow_polling"
  workflow_id          = google_workflows_workflow.workflow.id
  input_workflow_state = module.workflow_polling_1.workflow_state

  depends_on = [
    module.workflow_polling_1
  ]
}

# TODO: Expand testing to support more dynamic polling of workflow state
# module "workflow_polling_1" {
#   source = "./workflow_polling"

#   workflow_id          = google_workflows_workflow.workflow.id
#   input_workflow_state = null

#   depends_on = [
#     google_storage_bucket.raw_bucket,
#     google_bigquery_routine.sp_bigqueryml_generate_create,
#     google_bigquery_routine.sp_bigqueryml_model,
#     google_bigquery_routine.sproc_sp_demo_lookerstudio_report,
#     google_bigquery_routine.sp_provision_lookup_tables,
#     google_workflows_workflow.workflow,
#     google_storage_bucket.raw_bucket,
#     google_cloudfunctions2_function.notebook_deploy_function,
#     time_sleep.wait_after_function,
#     google_service_account_iam_member.workflow_auth_function
#   ]
# }

# module "workflow_polling_2" {
#   source      = "./workflow_polling"
#   workflow_id = google_workflows_workflow.workflow.id

#   input_workflow_state = module.workflow_polling_1.workflow_state

#   depends_on = [
#     module.workflow_polling_1
#   ]
# }

# module "workflow_polling_3" {
#   source      = "./workflow_polling"
#   workflow_id = google_workflows_workflow.workflow.id

#   input_workflow_state = module.workflow_polling_2.workflow_state

#   depends_on = [
#     module.workflow_polling_2
#   ]
# }

# module "workflow_polling_4" {
#   source      = "./workflow_polling"
#   workflow_id = google_workflows_workflow.workflow.id

#   input_workflow_state = module.workflow_polling_3.workflow_state

#   depends_on = [
#     module.workflow_polling_3
#   ]
# }
