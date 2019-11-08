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

output "dataset_id" {
  description = "Project ID"
  value       = var.dataset_id
}

output "project_id" {
  description = "Project ID"
  value       = var.project_id
}

output "authorized_views_fqns" {
  description = "FQNs of any authorized views created"
  value = [
    for view in var.authorized_views :
    join(".", var.project_id, var.dataset_id, view["view_name"])
  ]
}
