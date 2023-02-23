/**
 * Copyright 2021 Google LLC
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

output "lookerstudio_report_url" {
  description = "Looker Studio URL"
  value       = module.data_warehouse.lookerstudio_report_url
}

output "bigquery_editor_url" {
  description = "BQ editor URL"
  value       = module.data_warehouse.bigquery_editor_url
}

output "raw_bucket" {
  description = "Raw bucket name"
  value       = module.data_warehouse.raw_bucket
}
