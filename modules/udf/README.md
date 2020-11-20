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

local {
  parse_url_udf_ddl = <<EOT
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

module "add_udfs" {
  source = "terraform-google-modules/bigquery/google//modules/udf"
  version = "~> 4.0"

  dataset_id = module.dataset.bigquery_dataset.dataset_id
  project_id = module.dataset.bigquery_dataset.project
  udf_ddl_query = [parse_url_udf_ddl, ]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dataset\_id | Default Dataset ID in which to deploy the cloud function (this may be overwritten in the UDF DDL) | string | n/a | yes |
| project\_id | Default Project ID that contains the dataset (this may be overwritten in the UDF DDL) | string | n/a | yes |
| udf\_ddl\_query | Query Defining this UDF. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| added\_udfs | Name of the UDF created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
