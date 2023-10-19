# BigQuery Scheduled Queries

This submodule is used to create [scheduled queries](https://cloud.google.com/bigquery/docs/scheduling-queries) that can be run on a recurring basis.


Example:
```hcl
module "dataset" {
  source = "terraform-google-modules/bigquery/google"
  version = "~> 7.0"

  dataset_id                  = "example_dataset"
  dataset_name                = "example_dataset"
  description                 = "example description"
  project_id                  = "example-project"
  location                    = "EU"
}

module "scheduled_queries" {
  source = "terraform-google-modules/bigquery/google//modules/scheduled_queries"
  version = "~> 5.3.0"

  project_id = module.dataset.bigquery_dataset.project_id

  queries = [
    {
      name                   = "my-query"
      location               = "EU"
      data_source_id         = "scheduled_query"
      destination_dataset_id = module.dataset.bigquery_dataset.dataset_id
      params = {
        destination_table_name_template = "my_table"
        write_disposition               = "WRITE_APPEND"
        query                           = "SELECT name FROM tabl WHERE x = 'y'"
      }
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project where scheduled queries are created | `string` | n/a | yes |
| queries | Data transfer configuration for creating scheduled queries | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| query\_names | The resource names of the transfer config |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
