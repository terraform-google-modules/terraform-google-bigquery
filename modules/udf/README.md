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
  version = "~> 7.0"

  dataset_id = module.dataset.bigquery_dataset.dataset_id
  project_id = module.dataset.bigquery_dataset.project
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_udfs | Whether or not this module should be enabled. | `string` | `false` | no |
| dataset\_id | Dataset id | `string` | n/a | yes |
| project\_id | Project ID that contains the dataset | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| added\_udfs | List of UDFs utility functions added. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
