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

variable "authorized_views" {
  description = "An object defining an authorized view to create, table_name: Full table name in the form: project.dataset.table, view_name: Full view name in the form: project.dataset.view, blacklist: Comma separated list of fields to exclude in source table from view (defaults to none), schema_path: null or path to local JSON table schema."
  default     = []
  type = list(object({
    table_name  = string,
    view_name   = string,
    blacklist   = string,
    schema_path = string,
  }))
}

variable "dataset_id" {
  description = "Dataset where the table exists and the view will be created"
}

variable "project_id" {
  description = "Project where the dataset and table are created"
}

variable "bq_path" {
  description = "Full path to the bq CLI"
  default     = "bq"
}
