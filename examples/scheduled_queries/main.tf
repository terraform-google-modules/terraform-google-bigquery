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

module "dataset" {
  source = "../.."

  dataset_id   = "example_dataset"
  dataset_name = "example_dataset"
  description  = "Example description"
  project_id   = "example-project"
  location     = "EU"
}

module "scheduled_queries" {
  source = "../../modules/scheduled_queries"

  project_id = module.dataset.project

  queries = [
    {
      name                   = "my-query"
      location               = "EU"
      data_source_id         = "scheduled_query"
      destination_dataset_id = module.dataset.bigquery_dataset.dataset_id
      params = {
        destination_table_name_template = "my_table"
        write_disposition               = "WRITE_APPEND"
        query                           = "SELECT name FROM tabl WHERE x = 'y'"
      }
    }
  ]
}
