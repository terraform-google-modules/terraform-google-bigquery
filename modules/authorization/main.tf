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

locals {
  role_keys = [
    for role in var.roles :
    join("_", compact([
      role["role"],
      lookup(role, "domain", null),
      lookup(role, "group_by_email", null),
      lookup(role, "user_by_email", null),
      lookup(role, "special_group", null)
    ]))
  ]
  roles = zipmap(local.role_keys, var.roles)
  views = { for view in var.authorized_views : "${view["project_id"]}_${view["dataset_id"]}_${view["table_id"]}" => view }

  iam_to_primitive = {
    "roles/bigquery.dataOwner" : "OWNER"
    "roles/bigquery.dataEditor" : "WRITER"
    "roles/bigquery.dataViewer" : "READER"
  }
}

resource "google_bigquery_dataset_access" "authorized_view" {
  for_each   = local.views
  dataset_id = var.dataset_id
  project    = var.project_id
  view {
    project_id = each.value.project_id
    dataset_id = each.value.dataset_id
    table_id   = each.value.table_id
  }
}

resource "google_bigquery_dataset_access" "access_role" {
  for_each   = local.roles
  dataset_id = var.dataset_id
  project    = var.project_id
  # BigQuery API converts IAM to primitive roles in its backend.
  # This causes Terraform to show a diff on every plan that uses IAM equivalent roles.
  # Thus, do the conversion between IAM to primitive role here to prevent the diff.
  role           = lookup(local.iam_to_primitive, each.value.role, each.value.role)
  domain         = lookup(each.value, "domain", null)
  group_by_email = lookup(each.value, "group_by_email", null)
  user_by_email  = lookup(each.value, "user_by_email", null)
  special_group  = lookup(each.value, "special_group", null)
}
