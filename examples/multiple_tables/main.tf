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

module "bigquery" {
  source                      = "../.."
  dataset_id                  = "foo"
  dataset_name                = "foo"
  description                 = "some description"
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  project_id                  = var.project_id
  location                    = "US"
  tables                      = var.tables
  dataset_labels              = var.dataset_labels
}

module "add_udfs" {
  source = "../../modules/udf"

  dataset_id = module.bigquery.bigquery_dataset.dataset_id
  project_id = module.bigquery.bigquery_dataset.project
}
