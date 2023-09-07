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
  value       = "https://lookerstudio.google.com/reporting/create?c.reportId=1380cbd4-d7c5-4ad5-87c6-55bd33cab509&ds.ds_profit.datasourceName=lookerstudio_report_profit&ds.ds_profit.projectId=${var.project_id}&ds.ds_profit.type=VIEW&ds.ds_profit.datasetId=ds_edw&ds.ds_profit.tableId=lookerstudio_report_profit&ds.ds_dc.datasourceName=lookerstudio_report_distribution_centers&ds.ds_dc.projectId=${var.project_id}&ds.ds_dc.type=VIEW&ds.ds_dc.datasetId=ds_edw&ds.ds_dc.tableId=lookerstudio_report_distribution_centers"
  description = "The URL to create a new Looker Studio report displays a sample dashboard for the e-commerce data analysis"
}

output "bigquery_editor_url" {
  value       = "https://console.cloud.google.com/bigquery?project=${var.project_id}&ws=!1m5!1m4!6m3!1s${var.project_id}!2sds_edw!3ssp_sample_queries"
  description = "The URL to launch the BigQuery editor with the sample query procedure opened"
}

output "neos_tutorial_url" {
  value       = "https://console.cloud.google.com/products/solutions/deployments?walkthrough_id=panels--sic--data-warehouse_toc"
  description = "The URL to launch the in-console tutorial for the EDW solution"
}
