# BigQuery Persistent UDFs

This submodule adds some utility [user defined functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/user-defined-functions)
you may find useful when building BigQuery queries.

Example:
```
module "dataset" {
  source = "terraform-google-modules/bigquery/google"
  version "~> 4.0"

  dataset_id                  = "example_dataset"
  dataset_name                = "example_dataset"
  description                 = "example description"
  project_id                  = "example-project"
  location                    = "US"
}

module "add_udfs" {
  source = "terraform-google-modules/bigquery/google//modules/udf"
  version = "~> 4.0"

  dataset_id = module.dataset.bigquery_dataset.dataset_id
  project_id = module.dataset.bigquery_dataset.project
  udf_ddl_query = <<EOT
  CREATE FUNCTION IF NOT EXISTS parse_url(url STRING, part STRING)
  AS (
    CASE
      -- Return HOST part of the URL.
      WHEN part = 'HOST' THEN SPLIT(\`${PROJECT_ID}\`.${dataset_name}.check_protocol(url), '/')[OFFSET(2)]
      WHEN part = 'REF' THEN
        IF(REGEXP_CONTAINS(url, '#'), SPLIT(\`${PROJECT_ID}\`.${dataset_name}.check_protocol
        (url), '#')[OFFSET(1)], NULL)
      WHEN part = 'PROTOCOL' THEN RTRIM(REGEXP_EXTRACT(url, '^[a-zA-Z]+://'), '://')
      ELSE ''
    END
  );"
  EOT
}
```
