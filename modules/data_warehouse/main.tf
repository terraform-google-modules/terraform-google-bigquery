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
  version                     = "~> 18.0"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "aiplatform.googleapis.com",
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "compute.googleapis.com",
    "config.googleapis.com",
    "datacatalog.googleapis.com",
    "dataform.googleapis.com",
    "datalineage.googleapis.com",
    "notebooks.googleapis.com",
    "run.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com"
  ]

  activate_api_identities = [
    {
      api = "workflows.googleapis.com"
      roles = [
        "roles/workflows.viewer"
      ],
      api = "bigquerydatatransfer.googleapis.com"
      roles = [
        "roles/bigquerydatatransfer.serviceAgent"
      ]
    }
  ]
}

# Wait after APIs are enabled to give time for them to spin up
resource "time_sleep" "wait_after_apis" {
  create_duration = "30s"
  depends_on      = [module.project-services]
}

# resource "google_project_service_identity" "default" {
#   provider = google-beta
#   project = module.project-services.project_id
#   service = "workflows.googleapis.com"
# }

# Create random ID to be used for deployment uniqueness
resource "random_id" "id" {
  byte_length = 4
}

# Set up Storage Buckets
## Set up the raw storage bucket for data
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
