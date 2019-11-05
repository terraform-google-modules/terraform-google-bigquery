# view\_generator

Generates 1 or more [BigQuery views](https://cloud.google.com/bigquery/docs/authorized-views) without blacklisted fields. 

The views here must exist in the same project, but can be in different datasets & tables.

See `../../examples/multiple_tables` for an example of using this module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project ID where the dataset and table are created | string | `""` | yes |
| authorized\_views | A list of objects defining views to create, defined below | list | `[]` | yes |
| bq\_path | Full path to the bq CLI | string | `"bq"` | no |

## Views List
| table\_full\_name | Full table name in the form: project.dataset.table | string | n/a | yes |
| view\_full\_name | Full view name in the form: project.dataset.view | string | n/a | yes |
| blacklist | Comman separated list of fields to exclude in source table from view. Defaults to none. | string | `""` | yes |
| schema_path | Local path to schema JSON file for table | string | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | Project ID where the view is created |
