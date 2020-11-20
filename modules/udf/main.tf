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

 locals {
   // Regex to extract function name (optionally might include project and dataset ids)
   // see https://cloud.google.com/bigquery/docs/reference/standard-sql/user-defined-functions#temporary-udf-syntax
   // You can view test cases at: https://regex101.com/r/a7CNA6/2/
   function_name_regex = "CREATE\\s+(?:OR REPLACE\\s+)?FUNCTION\\s+(?:IF NOT EXISTS)?\\s*((?:[a-zA-Z0-9_]+.)*?(?:[a-zA-Z0-9_]+.)*?[a-zA-Z0-9_]+)(?=\\s*\\()"
   function_name = regex(local.function_name_regex, var.udf_ddl_query)
 }

module "udf" {
  for_each = toset(var.udf_ddl_queries)
  source  = "github.com/terraform-google-modules/terraform-google-gcloud"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = "--project_id ${var.project_id} query --dataset_id=${var.dataset_id} --use_legacy_sql=false '${var.udf_ddl_query}'"

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false 'DROP FUNCTION IF EXISTS ${local.function_name}'"
}
