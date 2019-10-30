# bigquery_view_generator

Generates big query views without blacklisted field.s

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| blacklist | Comman separated list of fields to exclude in source table from view. Defaults to none. | string | `""` | no |
| bq_path | Full path to the bq CLI | string | `"bq"` | no |
| table\_full\_name | Full table name in the form: project.dataset.table | string | n/a | yes |
| view\_full\_name | Full view name in the form: project.dataset.view | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| view\_dataset\_id | View dataset ID |
| view\_project\_id | View project ID |
| view\_table\_id | View table ID |
