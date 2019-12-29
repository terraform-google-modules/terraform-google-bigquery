/**
 * Copyright 2019 Google LLC
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

output "bigquery_dataset" {
  value       = module.bigquery.bigquery_dataset
  description = "Bigquery dataset resource."
}

output "bigquery_tables" {
  value       = module.bigquery.bigquery_tables
  description = "Map of bigquery table resources being provisioned."
}

output "dataset_id" {
  value       = module.bigquery.bigquery_dataset.dataset_id
  description = "Unique id for the dataset being provisioned"
}

output "dataset_name" {
  value       = module.bigquery.bigquery_dataset.friendly_name
  description = "Friendly name for the dataset being provisioned"
}

output "dataset_project" {
  value       = module.bigquery.dataset_project
  description = "Project where the dataset and table are created"
}

output "table_id" {
  value       = module.bigquery.table_id
  description = "Unique id for the table being provisioned"
}

output "table_name" {
  value       = module.bigquery.table_name
  description = "Friendly name for the table being provisioned"
}

output "dataset_labels" {
  value       = module.bigquery.dataset_labels
  description = "Key value pairs in a map for dataset labels"
}

output "table_labels" {
  value       = module.bigquery.table_labels
  description = "Key value pairs in a map for table labels"
}