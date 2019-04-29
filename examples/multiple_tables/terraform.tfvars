expiration = 3600000
project_id = "test-adigangi"
time_partitioning = "DAY"
dataset_labels = {
  env   = "dev"
  billable   = "true"
  owner = "janesmith"
}
table_labels = {
  env   = "dev"
  billable   = "true"
  owner = "joedoe"
}
tables = [
  {
    table_id = "foo",
    schema = "sample_bq_schema.json"
  },
  {
    table_id = "bar",
    schema = "sample_bq_schema.json"
  }
]
