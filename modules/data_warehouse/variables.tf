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

variable "project_id" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "Google Cloud Region"

  validation {
    condition     = contains(["us-central1", "us-west4", "europe-west1", "europe-west2", "europe-west3", "europe-west4", "europe-west9", "asia-northeast3", "asia-southeast1"], var.region)
    error_message = "This region is not supported. Region must be one of us-central1, us-west4, europe-west1, europe-west2, europe-west3, europe-west4, europe-west9, asia-northeast3, asia-southeast1."
  }
}

variable "text_generation_model_name" {
  type        = string
  description = "Name of the BigQuery ML GenAI remote model that connects to the LLM used for text generation"
  default     = "text_generate_model"

}
variable "labels" {
  type        = map(string)
  description = "A map of labels to apply to contained resources."
  default     = { "data-warehouse" = true }
}

variable "enable_apis" {
  type        = string
  description = "Whether or not to enable underlying apis in this solution."
  default     = true
}

variable "force_destroy" {
  type        = string
  description = "Whether or not to protect BigQuery resources from deletion when solution is modified or changed."
  default     = false
}

variable "deletion_protection" {
  type        = string
  description = "Whether or not to protect GCS resources from deletion when solution is modified or changed."
  default     = true
}


