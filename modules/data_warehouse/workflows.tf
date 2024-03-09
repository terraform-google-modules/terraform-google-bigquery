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

  depends_on = [google_dataform_repository_iam_member.workflow_manage_repo]
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

  labels = var.labels

  depends_on = [
    google_project_iam_member.workflow_manage_sa_roles,
    time_sleep.wait_after_function
  ]
}

# data "google_client_config" "current" {

# }

# ## Trigger the execution of the setup workflow with an API call
# data "http" "call_workflows_setup" {
#   url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow.name}/executions"
#   method = "POST"
#   request_headers = {
#     Accept = "application/json"
#   Authorization = "Bearer ${data.google_client_config.current.access_token}" }
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

# # Sleep for 120 seconds to allow the workflow to execute and finish setup
# resource "time_sleep" "wait_after_workflow_execution" {
#   create_duration = "120s"
#   depends_on = [
#     data.http.call_workflows_setup,
#   ]
# }

# ## Trigger the execution of the setup workflow with an API call
# data "http" "call_workflows_state_1" {
#   url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow.name}/executions"
#   method = "GET"
#   request_headers = {
#     Accept = "application/json"
#   Authorization = "Bearer ${data.google_client_config.current.access_token}" }
#   depends_on = [
#     time_sleep.wait_after_workflow_execution,
#   ]
# }

# data "http" "retry_workflows_1" {
#   count  = jsonencode(data.http.call_workflows_state_1).executions[0].state == "SUCCEEDED" || data.http.call_workflows_state_1.executions[0].state == "ACTIVE" ? 0 : 1
#   url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow.name}/executions"
#   method = "POST"
#   request_headers = {
#     Accept = "application/json"
#   Authorization = "Bearer ${data.google_client_config.current.access_token}" }
#   depends_on = [
#   data.http.call_workflows_state_1]
# }

# # Sleep for 30 seconds to recheck the workflow state
# resource "time_sleep" "wait_to_recheck_workflow" {
#   create_duration = "30s"
#   depends_on = [
#     data.http.retry_workflows_1,
#   ]
# }

# ## Trigger the execution of the setup workflow with an API call
# data "http" "call_workflows_state_2" {
#   count  = data.http.call_workflows_state_2.executions[0].state == "SUCCEEDED" || data.http.call_workflows_state_2.executions[0].state == "ACTIVE" ? 0 : 1
#   url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow.name}/executions"
#   method = "GET"
#   request_headers = {
#     Accept = "application/json"
#   Authorization = "Bearer ${data.google_client_config.current.access_token}" }
#   depends_on = [
#     time_sleep.wait_to_recheck_workflow,
#   ]
# }

# data "http" "retry_workflows_2" {
#   count  = data.http.call_workflows_state.executions[0].state == "SUCCEEDED" || data.http.call_workflows_state.executions[0].state == "ACTIVE" ? 0 : 1
#   url    = "https://workflowexecutions.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/workflows/${google_workflows_workflow.workflow.name}/executions"
#   method = "POST"
#   request_headers = {
#     Accept = "application/json"
#   Authorization = "Bearer ${data.google_client_config.current.access_token}" }
#   depends_on = [
#   data.http.call_workflows_state_2]
# }

# Sleep for 120 seconds to allow the workflow to execute and finish setup
resource "time_sleep" "complete_workflow" {
  # count  = data.http.call_workflows_state_1.executions[0].state == "SUCCEEDED" ? 0 : 1
  create_duration = "120s"
  depends_on = [
    # data.http.retry_workflows_1,
  ]
}
