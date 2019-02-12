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
   Provider configuration
  *****************************************/
provider "google" {
  version = "~> 1.20.0"
}

module "bigquery" {
  source            = "../../.."
  dataset_id        = "${var.dataset_id}"
  dataset_name      = "${var.dataset_name}"
  description       = "${var.description}"
  expiration        = "${var.expiration}"
  project_id        = "${var.project_id}"
  location            = "${var.location}"
  table_id          = "${var.table_id}"
  time_partitioning = "${var.time_partitioning}"
  schema_file       = "${var.schema_file}"
  dataset_labels    = "${var.dataset_labels }"
  table_labels      = "${var.table_labels}"
}
