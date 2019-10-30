expiration        = 3600000
time_partitioning = "DAY"
dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
tables = [
  {
    table_id = "foo",
    schema   = "sample_bq_schema.json",
    labels = {
      env      = "dev"
      billable = "true"
      owner    = "joedoe"
    },
  },
  {
    table_id = "bar",
    schema   = "sample_bq_schema.json",
    labels = {
      env      = "devops"
      billable = "true"
      owner    = "joedoe"
    },
  }
]
authorized_views = [{
	table_full_name = "my-project.foo.foo"
	view_full_name = "my-project.foo.foo_view"
	blacklist = "foo"
},{
	table_full_name = "my-project.foo.bar"
	view_full_name = "my-project.foo.bar_view"
	blacklist = "visitId,fullVisitorId"
}]
