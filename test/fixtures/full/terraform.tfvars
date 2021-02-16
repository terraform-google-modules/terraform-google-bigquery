default_table_expiration_ms = 3600000
dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
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
