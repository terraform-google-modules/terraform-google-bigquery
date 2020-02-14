# BigQuery Persistent UDFs

This submodule adds some utility [user defined functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/user-defined-functions)
you may find useful when building BigQuery queries.

Example:

module "add_udfs" {
  source = source  = "terraform-google-modules/bigquery/google//modules/udf"
  version = "~> 3.0"

  dataset_id = "example_dataset"
  project_id = "example-project"
}
