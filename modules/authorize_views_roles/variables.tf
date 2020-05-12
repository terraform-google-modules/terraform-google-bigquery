/**
 * Copyright 2020 Google LLC
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
  type        = string
}

variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}

# Format: list(objects)
# domain: A domain to grant access to.
# group_by_email: An email address of a Google Group to grant access to.
# user_by_email:  An email address of a user to grant access to.
# group_by_email: An email address of a Google Group to grant access to.
# special_group: A special group to grant access to.
variable "roles" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any
  default     = []
}

variable "authorized_views" {
  description = "An array of views to give authorize for the dataset"
  type = list(object({
    dataset_id = string,
    project_id = string,
    table_id   = string # this is the view id, but we keep table_id to stay consistent as the resource
  }))
}
