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

variable "dataset_id" {
  description = "Unique ID for the dataset being provisioned."
}

variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned."
}

variable "description" {
  description = "Dataset description."
}

variable "location" {
  description = "The regional location for the dataset only US and EU are allowed in module"
  default     = "US"
}

variable "default_table_expiration_ms" {
  description = "TTL of tables using the dataset in MS"
  default     = null
}

variable "project_id" {
  description = "Project where the dataset and table are created"
}

variable "dataset_labels" {
  description = "Key value pairs in a map for dataset labels"
  type        = map(string)
}

variable "tables" {
  description = "A list of objects which include table_id, schema, clustering, time_partitioning, expiration_time and labels."
  default     = []
  type = list(object({
    table_id   = string,
    schema     = string,
    clustering = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    expiration_time = string,
    view = object({
      query          = string,
      use_legacy_sql = bool,
    }),
    labels = map(string),
  }))
}

variable "access" {
  description = "An array of objects that define dataset access for one or more entities. [Link to the structure] (https://www.terraform.io/docs/providers/google/r/bigquery_dataset.html#access)"
  default     = []
  type = list(object({
    domain         = string
    group_by_email = string
    role           = string
    special_group  = string
    user_by_email  = string
    view = object({
      dataset_id = string
      project_id = string
      table_id   = string
    })
  }))
}
