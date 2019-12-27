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

/******************************************
   Provider configuration
  *****************************************/
provider "google" {
  version = "~> 3.0.0"
}

module "bigquery" {
  source                     = "../.."
  dataset_id                 = "foo"
  dataset_name               = "foo"
  description                = "some description"
  project_id                 = var.project_id
  location                   = "US"
  tables                     = var.tables
  dataset_labels             = var.dataset_labels
  delete_contents_on_destroy = true
  authorized_views = [
    {
      table_name  = "foo"
      view_name   = "foo_view"
      blacklist   = "",
      schema_path = "examples/multiple_tables/sample_bq_schema.json"
    },
    {
      table_name  = "bar"
      view_name   = "bar_view"
      blacklist   = "visitId,fullVisitorId",
      schema_path = null
    }
  ]
}
