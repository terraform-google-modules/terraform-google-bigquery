/**
 * Copyright 2026 Google LLC
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

# Capture the deployment timestamp to ensure a one-time execution
resource "time_static" "transfer_start" {}

# Get the Storage Transfer Service Google-managed service account
data "google_storage_transfer_project_service_account" "default" {
  project = module.project-services.project_id

  depends_on = [time_sleep.wait_after_apis]
}

# Grant the Storage Transfer Service access to write to our staging bucket
resource "google_storage_bucket_iam_member" "transfer_sa_sink" {
  bucket = google_storage_bucket.raw_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
}

# Create the transfer job to run exactly once immediately upon deployment
resource "google_storage_transfer_job" "copy_demos_data" {
  description = "One-time initial transfer of thelook-ecommerce sample data"
  project     = module.project-services.project_id

  transfer_spec {
    gcs_data_source {
      bucket_name = "data-analytics-demos"
      path        = "thelook-ecommerce/"
    }
    gcs_data_sink {
      bucket_name = google_storage_bucket.raw_bucket.name
      path        = "thelook-ecommerce/"
    }
  }

  schedule {
    schedule_start_date {
      year  = time_static.transfer_start.year
      month = time_static.transfer_start.month
      day   = time_static.transfer_start.day
    }
    schedule_end_date {
      year  = time_static.transfer_start.year
      month = time_static.transfer_start.month
      day   = time_static.transfer_start.day
    }
  }

  depends_on = [
    google_storage_bucket_iam_member.transfer_sa_sink
  ]
}

# Wait for the one-time data transfer to finish before allowing downstream BigQuery queries
resource "time_sleep" "wait_after_data_transfer" {
  create_duration = "90s"
  depends_on      = [google_storage_transfer_job.copy_demos_data]
}

