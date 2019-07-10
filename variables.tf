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
  description = "Unique ID for the dataset being provisioned"
}

variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned"
}

variable "description" {
  description = "Dataset description"
}

variable "location" {
  description = "The regional location for the dataset only US and EU are allowed in module"
  default     = "US"
}

variable "expiration" {
  description = "TTL of tables using the dataset in MS"
  default     = null
}

variable "project_id" {
  description = "Project wheree the dataset and table are created"
}

variable "time_partitioning" {
  description = "Configures time-based partitioning for this table"
}

variable "dataset_labels" {
  description = "Key value pairs in a map for dataset labels"
  type        = map(string)
}

variable "tables" {
  description = "A list of objects which include table_id, schema, and labels."
  default     = []
  type        = list(object({
    table_id  = string,
    schema    = string,
    labels    = map(string),
  }))
}

