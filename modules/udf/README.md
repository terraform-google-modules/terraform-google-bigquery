# BigQuery Persistent UDFs

This submodule adds some utility [user defined functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/user-defined-functions)
you may find useful when building BigQuery queries.
Note, that DDL queries should NOT contain `[project.[dataset.]]` prefix for function name.
The project / dataset will be set by the module.

Example:
```
module "dataset" {
  source = "terraform-google-modules/bigquery/google"
  version = "~> 4.0"

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
  );
  EOT
  udf_from_file = file(${path.module}/path/to/udf_ddl.sql)
}

module "add_udfs" {
  source = "terraform-google-modules/bigquery/google//modules/udf"
  version = "~> 4.0"

  dataset_id = module.dataset.bigquery_dataset.dataset_id
  project_id = module.dataset.bigquery_dataset.project
  udf_ddl_query = [local.parse_url_udf_ddl, local.udf_from_file, ]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dataset\_id | Dataset ID in which to deploy the UDF | string | n/a | yes |
| project\_id | Project ID that contains the dataset in which to deploy the UDF | string | n/a | yes |
| udf\_ddl\_queries | Queries Defining the UDFs to deploy in the dataset. | list(string) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| added\_udfs | Name of the UDF created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Limitations
This module will not infer the order in which to create UDFs in the case of
nested UDFs which may cause failed applies due to 'Function not found' errors.
One can work around this by separating UDF definitions into multiple
instantiations of this module with terraform v0.13's module `depends_on` feature.
Note, DDL for UDFs that call other UDFs must use the fully qualified name of the
UDFs they call.

```hcl
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
  dataset_fqn = "${module.dataset.bigquery_dataset.project}.${module.dataset.bigquery_dataset.dataset_id}"

  primitive_udfs = {
      foo = <<EOT
        CREATE FUNCTION IF NOT EXISTS foo(x INT64)
        AS(
          x + 1
        )
      EOT

      bar = <<EOT
        CREATE FUNCTION IF NOT EXISTS bar(x INT64)
        AS(
          x  * 2
        )
      EOT
  }

  second_order_udfs = {
    foo_of_bar = <<EOT
      CREATE FUNCTION IF NOT EXISTS foo_of_bar(x INT64)
      AS(
        ${local.dataset_fqn}.foo(
          ${local.dataset_fqn}.bar(x)
        )
      )
    EOT
  }
}

module "primitive_udfs" {
  source        = "terraform-google-modules/bigquery/google//modules/udf"
  version       = "~> 4.0"

  dataset_id    = module.dataset.bigquery_dataset.dataset_id
  project_id    = module.dataset.bigquery_dataset.project
  udf_ddl_query = values(local.primitive_udfs)
}

module "second_order_udfs" {
  depends_on    = [module.primitive_udfs]
  source        = "terraform-google-modules/bigquery/google//modules/udf"
  version       = "~> 4.0"

  dataset_id    = module.dataset.bigquery_dataset.dataset_id
  project_id    = module.dataset.bigquery_dataset.project
  udf_ddl_query = values(local.second_order_udfs)
}
```
