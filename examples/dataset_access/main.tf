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
  source                      = "../.."
  dataset_id                  = "plane"
  dataset_name                = "plane"
  description                 = "some description"
  default_table_expiration_ms = var.expiration
  project_id                  = var.project_id
  location                    = "US"
  dataset_labels              = var.dataset_labels
  tables = [
    {
      table_id          = "foo",
      schema            = "/workspace/examples/dataset_access/sample_bq_schema.json",
      clustering        = [],
      time_partitioning = null,
      expiration_time   = null,
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
    },
    {
      table_id          = "bar",
      schema            = "/workspace/examples/dataset_access/sample_bq_schema.json",
      clustering        = [],
      time_partitioning = null,
      expiration_time   = null,
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
}

module "dataset_access" {
  source     = "../../modules/dataset_access"
  dataset_id = module.bigquery.bigquery_dataset.dataset_id
  project    = var.project_id

  preserve_special_groups = true
  roles_json              = "${file("/workspace/examples/dataset_access/roles.json")}"

  // Uncomment if running tests on a mac
  platform = "darwin"
}
