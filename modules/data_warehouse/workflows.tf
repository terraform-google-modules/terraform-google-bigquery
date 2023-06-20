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

resource "google_project_service_identity" "workflows" {
  provider = google-beta
  project  = module.project-services.project_id
  service  = "workflows.googleapis.com"

  depends_on = [
    module.project-services
  ]
}

# Set up Workflows service account
# # Set up the Workflows service account
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
  ])

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

  source_contents = templatefile("${path.module}/src/workflows/workflow.yaml", {
    raw_bucket = google_storage_bucket.raw_bucket.name
  })

  depends_on = [
    google_project_iam_member.workflow_service_account_roles,
    google_project_service_identity.workflows,
  ]
}
