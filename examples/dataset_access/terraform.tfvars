project_id        = "example-project"
time_partitioning = "DAY"
dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
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
