/*
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

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "14.3"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "aiplatform.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "config.googleapis.com",
    "datacatalog.googleapis.com",
    "datalineage.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
    "workflows.googleapis.com",
  ]

  activate_api_identities = [
    {
      api = "workflows.googleapis.com"
      roles = [
        "roles/workflows.viewer"
      ]
    }
  ]
}

resource "time_sleep" "wait_after_apis" {
  create_duration = "90s"
  depends_on      = [module.project-services]
}

## Create random ID to be used for deployment uniqueness
resource "random_id" "id" {
  byte_length = 4
}

# Set up Storage Buckets
# # Set up the raw storage bucket
resource "google_storage_bucket" "raw_bucket" {
  name                        = "ds-edw-raw-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  public_access_prevention = "enforced"

  depends_on = [time_sleep.wait_after_apis]

  labels = var.labels
}

# # Set up the provisioning storage bucket
resource "google_storage_bucket" "provisioning_bucket" {
  name                        = "ds-edw-provisioner-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  public_access_prevention = "enforced"

  depends_on = [time_sleep.wait_after_apis]

  labels = var.labels
}

# # Get the GCS service account to trigger the pub/sub notification
data "google_storage_project_service_account" "gcs_account" {
  project = module.project-services.project_id

  depends_on = [time_sleep.wait_after_apis]
}

// Sleep for 120 seconds to drop start file
resource "time_sleep" "wait_to_startfile" {
  depends_on = [
    google_workflows_workflow.workflow
  ]

  create_duration = "120s"
}

// Drop start file for workflow to execute
resource "google_storage_bucket_object" "startfile" {
  bucket = google_storage_bucket.provisioning_bucket.name
  name   = "startfile"
  source = "${path.module}/src/startfile"

  depends_on = [
    time_sleep.wait_to_startfile
  ]
}

resource "time_sleep" "wait_after_workflow_execution" {
  create_duration = "120s"
  depends_on = [
    data.http.call_workflows_setup,
  ]
}
