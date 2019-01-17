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
locals {
  location = "${var.region == "US" || var.region == "EU" ? var.region : "module only supports EU or US"}"
}

resource "google_bigquery_dataset" "main" {
  dataset_id    = "${var.dataset_id}"
  friendly_name = "${var.dataset_name}"
  description   = "${var.description}"
  location      = "${local.location}"

  #TODO: terraform 0.12 will enable "expiration_mode ? a_table_expiration : null" (https://github.com/hashicorp/terraform/issues/17968)
  default_table_expiration_ms = "${var.expiration}"
  project                     = "${var.project_id}"
  labels                      = "${var.dataset_labels}"

  # TODO: revisit terraform 0.12 if arrays are available
  # access {
  #   role   = "READER"
  #   domain = "adigangi.com"
  # }
}

# TODO: Should be configured to create multiple tables on central dataset
resource "google_bigquery_table" "main" {
  dataset_id = "${google_bigquery_dataset.main.dataset_id}"
  table_id   = "${var.table_id}"
  project    = "${var.project_id}"

  #TODO: terraform 0.12 will enable "time_partitioning ? time_partitioning_is_required : null" (https://github.com/hashicorp/terraform/issues/17968)
  time_partitioning {
    type = "${var.time_partitioning}"
  }

  labels = "${var.table_labels}"

  schema = "${file("${var.schema_file}")}"
}
