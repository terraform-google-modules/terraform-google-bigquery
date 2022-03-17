/**
 * Copyright 2022 Google LLC
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

variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = null
}

variable "default_table_expiration_ms" {
  description = "Default TTL of tables using the dataset in MS."
  default     = null
}

variable "project_id" {
  description = "Project where the dataset and table are created."
}

variable "dataset_labels" {
  description = "A mapping of labels to assign to the table."
  type        = map(string)
}

variable "kms_key" {
  description = "The KMS key to use to encrypt data by default"
  type        = string
  default     = null
}
