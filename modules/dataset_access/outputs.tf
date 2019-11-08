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

output "roles" {
  description = "JSON roles applied to dataset"
  value       = local.roles
}

output "views" {
  description = "View permissions applied to dataset"
  value       = var.views
}

output "preserve_special_groups" {
  description = "Flag to preserve special groups on dataset"
  value       = var.preserve_special_groups
}

output "project" {
  description = "Project id where dataset lives."
  value       = var.project
}

output "dataset_id" {
  description = "Dataset where roles & permission were applied."
  value       = var.dataset_id
}

