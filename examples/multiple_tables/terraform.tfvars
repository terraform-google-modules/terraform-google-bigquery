project_id = "example-project"
time_partitioning = "DAY"
dataset_labels = {
  env   = "dev"
  billable   = "true"
  owner = "janesmith"
}
tables = [
  {
    table_id = "foo",
    schema = "sample_bq_schema.json",
    labels = {
      env = "dev"
      billable = "true"
      owner = "joedoe"
    },
  },
  {
    table_id = "bar",
    schema = "sample_bq_schema.json",
    labels = {
      env = "devops"
      billable = "true"
      owner = "joedoe"
    },
  }
]
