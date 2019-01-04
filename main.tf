/**
 * Copyright 2018 Google LLC
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
  Locals configuration
 *****************************************/
locals {}

resource "google_bigquery_dataset" "main" {
  dataset_id    = "${var.dataset_id}"
  friendly_name = "${var.dataset_name}"
  description   = "${var.description}"

  #TODO: add if condition to validate if neither US or EU are supplied
  location = "${var.region}"

  #TODO: format this ne excluded by default but can optionally be defined if the user wishes
  default_table_expiration_ms = "${var.expiration}"
  project                     = "${var.project_id}"

  #TODO: Need to find a way to dynamically assign a dict object(s)
  labels {
    env   = "default"
    foo   = "bar"
    tonyd = "tonyd"
  }

  //TODO: array of users or groups needs to be added to have access. Need to figure out the best method of customers to allocate users or groups.
  # access {
  #   role   = "READER"
  #   domain = "adigangi.com"
  # }
  #
  # access {
  #   role           = "WRITER"
  #   user_by_email = "adigangi@adigangi.com"
  # }
  #
  # access {
  #   role           = "OWNER"
  #   special_group  = "projectOwners"
  # }
}

resource "google_bigquery_table" "main" {
  dataset_id = "${google_bigquery_dataset.main.dataset_id}"
  table_id   = "${var.table_id}"
  project    = "${var.project_id}"

  #TODO: is this required?
  time_partitioning {
    type = "${var.time_partitioning}"
  }

  labels {
    env = "default"
  }

  schema = "${file("${var.schema_file}")}"
}
