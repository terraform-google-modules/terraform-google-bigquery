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

locals {
  tables = { for table in var.tables : table["table_id"] => table }
}

resource "google_bigquery_dataset" "main" {
  dataset_id    = var.dataset_id
  friendly_name = var.dataset_name
  description   = var.description
  location      = var.location

  default_table_expiration_ms = var.default_table_expiration_ms
  project                     = var.project_id
  labels                      = var.dataset_labels
}

resource "google_bigquery_table" "main" {
  for_each        = local.tables
  dataset_id      = google_bigquery_dataset.main.dataset_id
  friendly_name   = each.key
  table_id        = each.key
  labels          = each.value["labels"]
  schema          = file(each.value["schema"])
  expiration_time = each.value["expiration_time"]
  clustering      = each.value["clustering"]
  project         = var.project_id
  dynamic "time_partitioning" {
    for_each = each.value["time_partitioning"] != null ? [each.value["time_partitioning"]] : []
    content {
      type                     = time_partitioning.value["type"]
      expiration_ms            = time_partitioning.value["expiration_ms"]
      field                    = time_partitioning.value["field"]
      require_partition_filter = time_partitioning.value["require_partition_filter"]
    }
  }
}
