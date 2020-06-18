delete_contents_on_destroy = true
table_project_id           = "example-table-project"
table_dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
view_project_id = "example-view-project"
view_dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
tables = [
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

views = [
  {
    view_id        = "bar",
    use_legacy_sql = false,
    query          = <<EOF
      SELECT 
        fullVisitorId,
        visitId
      FROM
        `example-table-project.foo.bar`
      EOF
    # unfortunately we have to repeat the project id, dataset id and table id in here.
    labels = {
      env      = "devops"
      billable = "true"
      owner    = "joedoe"
    },
  }
]


