# view\_generator

Generates 1 or more [BigQuery views](https://cloud.google.com/bigquery/docs/authorized-views) without blacklisted fields.

The views here must exist in the same project, but can be in different datasets & tables.

See `../../examples/view_generator` for an example of using this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| authorized\_views | An object defining an authorized view to create, table_name: Full table name in the form: project.dataset.table, view_name: Full view name in the form: project.dataset.view, blacklist: Comma separated list of fields to exclude in source table from view (defaults to none), schema_path: null or path to local JSON table schema. | object | `<list>` | no |
| bq\_path | Full path to the bq CLI | string | `"bq"` | no |
| dataset\_id | Dataset where the table exists and the view will be created | string | n/a | yes |
| project\_id | Project where the dataset and table are created | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| authorized\_views\_fqns | FQNs of any authorized views created |
| dataset\_id | Project ID |
| project\_id | Project ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
