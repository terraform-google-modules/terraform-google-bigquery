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
  tables = [
    {
      table_id = "foo",
      schema   = "sample_bq_schema.json",
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      expiration_time = null,
      clustering      = ["fullVisitorId", "visitId"],
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
    },
    {
      table_id          = "bar",
      schema            = "sample_bq_schema.json",
      time_partitioning = null,
      expiration_time   = 2524604400000, # 2050/01/01
      clustering        = [],
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
  external_tables = [
    {
      table_id              = "csv_example"
      autodetect            = true
      compression           = null
      ignore_unknown_values = true
      max_bad_records       = 0
      source_format         = "CSV"
      schema                = null
      expiration_time       = 2524604400000 # 2050/01/01
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      }
      source_uris = ["gs://terraform-gcp-bigquery-external-data/bigquery-external-table-test.csv"]
      csv_options = {
        quote                 = "\""
        allow_jagged_rows     = false
        allow_quoted_newlines = true
        encoding              = "UTF-8"
        field_delimiter       = ","
        skip_leading_rows     = 1
      }
      hive_partitioning_options = null
      google_sheets_options     = null
    },
    {
      table_id              = "hive_example"
      autodetect            = true
      compression           = null
      ignore_unknown_values = true
      max_bad_records       = 0
      source_format         = "CSV"
      schema                = null
      expiration_time       = 2524604400000 # 2050/01/01
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      }
      source_uris = [
        "gs://terraform-gcp-bigquery-external-data/hive_partition_example/year=2012/foo.csv",
        "gs://terraform-gcp-bigquery-external-data/hive_partition_example/year=2013/bar.csv"
      ]
      csv_options = null
      hive_partitioning_options = {
        mode              = "AUTO"
        source_uri_prefix = "gs://terraform-gcp-bigquery-external-data/hive_partition_example/"
      }
      google_sheets_options = null
    }
  ]
  dataset_labels = var.dataset_labels
  encryption_key = var.kms_key
}

module "add_udfs" {
  source = "../../modules/udf"

  dataset_id = module.bigquery.bigquery_dataset.dataset_id
  project_id = module.bigquery.bigquery_dataset.project
}
