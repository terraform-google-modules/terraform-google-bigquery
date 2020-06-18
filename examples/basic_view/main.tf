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


module "bigquery_tables" {
  source                     = "../.."
  dataset_id                 = "foo"
  dataset_name               = "foo"
  description                = "some description"
  project_id                 = var.table_project_id
  location                   = "US"
  delete_contents_on_destroy = var.delete_contents_on_destroy
  tables                     = var.tables
  dataset_labels             = var.table_dataset_labels

  # we provide the access control separately with another module, see bottom.
  # Authorization module has the capability of authorizing views
  # since access block in here conflicts with that, we only use the module.
  access = []
}

module "bigquery_views_without_pii" {
  source                     = "../.."
  dataset_id                 = "${module.bigquery_tables.bigquery_dataset.dataset_id}_view_without_pii" # this creates a dependency so that we have the tables first
  dataset_name               = "foo view"
  description                = "some description"
  project_id                 = var.view_project_id
  delete_contents_on_destroy = var.delete_contents_on_destroy
  location                   = "US"
  views                      = var.views
  dataset_labels             = var.view_dataset_labels

  access = [
    {
      role          = "roles/bigquery.dataOwner"
      special_group = "projectOwners"
    }
  ]
}

# it is possible to pass the view access to a dataset resource but then we have a chicken-egg problem.
# the view wants first the tables are created, while the view access control needs the views
# so we create the authorized views after creating tables and views.
module "authorization" {
  source     = "../../modules/authorization"
  project_id = var.table_project_id
  dataset_id = module.bigquery_tables.bigquery_dataset.dataset_id

  roles = []
  # roles = [
  #   {
  #     role           = "roles/bigquery.dataEditor"
  #     group_by_email = "ops@mycompany.com"
  #   }
  # ]

  authorized_views = [
    for view in var.views :
    {
      project_id = var.view_project_id,
      dataset_id = module.bigquery_views_without_pii.bigquery_dataset.dataset_id,
      table_id   = view.view_id
    }
  ]
}
