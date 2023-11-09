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
  version                     = "14.4"
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
    "eventarc.googleapis.com",
    "pubsub.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
    "workflows.googleapis.com",
  ]

  activate_api_identities = [
    {
      api = "pubsub.googleapis.com"
      roles = [
        "roles/iam.serviceAccountTokenCreator",
      ]
    },
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

// Create random ID to be used for deployment uniqueness
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

// Create Eventarc Trigger
# # Create a Pub/Sub topic.
resource "google_pubsub_topic" "topic" {
  name    = "provisioning-topic"
  project = module.project-services.project_id

  depends_on = [time_sleep.wait_after_apis]

  labels = var.labels
}

resource "google_pubsub_topic_iam_binding" "binding" {
  project = module.project-services.project_id
  topic   = google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

# # Get the GCS service account to trigger the pub/sub notification
data "google_storage_project_service_account" "gcs_account" {
  project = module.project-services.project_id

  depends_on = [time_sleep.wait_after_apis]
}

# # Create the Storage trigger
resource "google_storage_notification" "notification" {
  provider       = google
  bucket         = google_storage_bucket.provisioning_bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  depends_on = [
    google_pubsub_topic_iam_binding.binding,
  ]
}

# # Create the Eventarc trigger
resource "google_eventarc_trigger" "trigger_pubsub_tf" {
  project  = module.project-services.project_id
  name     = "trigger-pubsub-tf"
  location = var.region
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"

  }
  destination {
    workflow = google_workflows_workflow.workflow.id
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.topic.id
    }
  }
  service_account = google_service_account.eventarc_service_account.email

  labels = var.labels

  depends_on = [
    google_project_iam_member.eventarc_service_account_invoke_role,
  ]
}

# Set up Eventarc service account for the Trigger to execute as
# # Set up the Eventarc service account
resource "google_service_account" "eventarc_service_account" {
  project      = module.project-services.project_id
  account_id   = "eventarc-sa-${random_id.id.hex}"
  display_name = "Service Account for Cloud Eventarc"

  depends_on = [time_sleep.wait_after_apis]
}

# # Grant the Eventarc service account Workflow Invoker Access
resource "google_project_iam_member" "eventarc_service_account_invoke_role" {
  project = module.project-services.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_service_account.email}"
}

// Sleep for 120 seconds to drop start file
resource "time_sleep" "wait_to_startfile" {
  depends_on = [
    google_storage_notification.notification,
    google_eventarc_trigger.trigger_pubsub_tf,
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
