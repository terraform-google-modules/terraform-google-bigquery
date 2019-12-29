default_table_expiration_ms = 3600000
dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
tables = [
  {
    table_id          = "foo",
    schema            = "sample_bq_schema.json",
    time_partitioning = null,
    expiration_time   = 2524604400000, # 2050/01/01
    clustering        = [],
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
