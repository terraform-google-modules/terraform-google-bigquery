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

output "ds_friendly_name" {
  value       = google_bigquery_dataset.ds_edw.friendly_name
  description = "Dataset name"
}

output "raw_bucket" {
  value       = google_storage_bucket.raw_bucket.name
  description = "Raw bucket name"
}

#TODO Create new Looker Studio Template
output "lookerstudio_report_url" {
  value       = "https://lookerstudio.google.com/reporting/create?c.reportId=402d64d6-2a14-45a1-b159-0dcc88c62cd5&ds.ds0.datasourceName=vw_taxi&ds.ds0.projectId=${var.project_id}&ds.ds0.type=TABLE&ds.ds0.datasetId=ds_edw&ds.ds0.tableId=vw_lookerstudio_report"
  description = "The URL to create a new Looker Studio report displays a sample dashboard for the taxi data analysis"
}

output "bigquery_editor_url" {
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}&ws=!1m5!1m4!6m3!1s${var.project_id}!2sds_edw!3ssp_sample_queries"
  description = "The URL to launch the BigQuery editor with the sample query procedure opened"
}

output "neos_tutorial_url" {
  value       = "https://console.cloud.google.com/products/solutions/deployments?walkthrough_id=panels--sic--data-warehouse_toc"
  description = "The URL to launch the in-console tutorial for the EDW solution"
}
