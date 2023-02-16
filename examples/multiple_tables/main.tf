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
      schema   = file("sample_bq_schema.json"),
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      range_partitioning = null,
      expiration_time    = null,
      clustering         = ["fullVisitorId", "visitId"],
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
    },
    {
      table_id          = "bar",
      schema            = file("sample_bq_schema.json"),
      time_partitioning = null,
      range_partitioning = {
        field = "visitNumber",
        range = {
          start    = "1"
          end      = "100",
          interval = "10",
        },
      },
      expiration_time = 2524604400000, # 2050/01/01
      clustering      = [],
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
      # DO NOT CHANGE - this is a publicly available file provided by Google
      # see here for reference: https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/pull/872
      source_uris = ["gs://ci-bq-external-data/bigquery-external-table-test.csv"]
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
      # DO NOT CHANGE - these are publicly available files provided by Google
      # see here for reference: https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/pull/872
      source_uris = [
        "gs://ci-bq-external-data/hive_partition_example/year=2012/foo.csv",
        "gs://ci-bq-external-data/hive_partition_example/year=2013/bar.csv"
      ]
      csv_options = null
      hive_partitioning_options = {
        mode = "AUTO"
        # DO NOT CHANGE - see above source_uris
        source_uri_prefix = "gs://ci-bq-external-data/hive_partition_example/"
      }
      google_sheets_options = null
    },
    {
      table_id              = "google_sheets_example"
      autodetect            = true
      compression           = null
      ignore_unknown_values = true
      max_bad_records       = 0
      source_format         = "GOOGLE_SHEETS"
      schema                = null
      expiration_time       = 2524604400000 # 2050/01/01
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      }
      # DO NOT CHANGE - this is a publicly available Google Sheet provided by Google
      # see here for reference: https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/pull/872
      source_uris               = ["https://docs.google.com/spreadsheets/d/15v4N2UG6bv1RmX__wru4Ei_mYMdVcM1MwRRLxFKc55s"]
      csv_options               = null
      hive_partitioning_options = null
      google_sheets_options = {
        range             = null
        skip_leading_rows = 1
      },
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

module "auth_dataset" {
  source                      = "../.."
  dataset_id                  = "auth_dataset"
  dataset_name                = "auth_dataset"
  description                 = "some description"
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  project_id                  = var.project_id
  location                    = "US"
  access                      = []
}

resource "google_bigquery_table" "auth_ds_table" {
  deletion_protection = false
  dataset_id          = module.auth_dataset.bigquery_dataset.dataset_id
  project             = module.auth_dataset.bigquery_dataset.project
  table_id            = "auth_db_table"

  view {
    query          = "SELECT 1 as col1 from (select SESSION_USER())"
    use_legacy_sql = false
  }
}

resource "google_bigquery_routine" "auth_ds_routine1" {
  dataset_id      = module.auth_dataset.bigquery_dataset.dataset_id
  project         = module.auth_dataset.bigquery_dataset.project
  routine_id      = "auth_ds_routine1"
  routine_type    = "TABLE_VALUED_FUNCTION"
  language        = "SQL"
  definition_body = <<-EOS
    SELECT 1 + value AS value
  EOS
  arguments {
    name          = "value"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" = "INT64" })
  }
  return_table_type = jsonencode({ "columns" = [
    { "name" = "value", "type" = { "typeKind" = "INT64" } },
  ] })
}

resource "google_bigquery_routine" "auth_ds_routine2" {
  dataset_id      = module.auth_dataset.bigquery_dataset.dataset_id
  project         = module.auth_dataset.bigquery_dataset.project
  routine_id      = "auth_ds_routine2"
  routine_type    = "TABLE_VALUED_FUNCTION"
  language        = "SQL"
  definition_body = <<-EOS
    SELECT 2 + value AS value
  EOS
  arguments {
    name          = "value"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" = "INT64" })
  }
  return_table_type = jsonencode({ "columns" = [
    { "name" = "value", "type" = { "typeKind" = "INT64" } },
  ] })
}

module "add_authorization" {
  source = "../../modules/authorization"

  dataset_id = module.bigquery.bigquery_dataset.dataset_id
  project_id = module.bigquery.bigquery_dataset.project
  authorized_views = [
    {
      project_id = module.auth_dataset.bigquery_dataset.project
      dataset_id = module.auth_dataset.bigquery_dataset.dataset_id
      table_id   = google_bigquery_table.auth_ds_table.table_id
    },
  ]
  authorized_datasets = [
    {
      dataset_id = module.auth_dataset.bigquery_dataset.dataset_id
      project_id = module.auth_dataset.bigquery_dataset.project
    },
  ]

  authorized_routines = [
    {
      dataset_id = google_bigquery_routine.auth_ds_routine1.dataset_id
      project_id = google_bigquery_routine.auth_ds_routine1.project
      routine_id = google_bigquery_routine.auth_ds_routine1.routine_id
    },
    {
      dataset_id = google_bigquery_routine.auth_ds_routine2.dataset_id
      project_id = google_bigquery_routine.auth_ds_routine2.project
      routine_id = google_bigquery_routine.auth_ds_routine2.routine_id
    },
  ]

  depends_on = [
    module.auth_dataset
  ]
}
