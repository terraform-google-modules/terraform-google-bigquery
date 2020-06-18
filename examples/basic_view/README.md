# terraform-google-bigquery basic_view
The basic_view example uses the root terraform-google-bigquery module to deploy a dataset and a table with a basic schema.
Additionally, it creates another dataset with a view on the table.
This is a common practice for providing limited data in a different dataset.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default\_table\_expiration\_ms | Default TTL of tables using the dataset in MS. | string | `"null"` | no |
| delete\_contents\_on\_destroy | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | bool | `"null"` | no |
| table\_dataset\_labels | A mapping of labels to assign to the table. | map(string) | n/a | yes |
| table\_project\_id | Project where the dataset and table are created. | string | n/a | yes |
| tables | A list of maps that includes table_id, schema, clustering, time_partitioning, view, expiration_time, labels in each element. | object | `<list>` | no |
| view\_dataset\_labels | A mapping of labels to assign to the table. | map(string) | n/a | yes |
| view\_project\_id | Project where the dataset and table are created. | string | n/a | yes |
| views | A list of objects which include table_id, which is view id, and view query | object | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_roles | Map of roles assigned to identities |
| authorized\_views | Map of authorized views created |
| bigquery\_dataset | Bigquery dataset resource. |
| bigquery\_dataset\_view | Bigquery dataset resource. |
| bigquery\_tables | Map of bigquery table resources being provisioned. |
| bigquery\_views | Map of bigquery table/view resources being provisioned. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Setup
Update the contents of `terraform.tfvars` to match your test environment.

## Run example
```
terraform init
terraform plan
terraform apply -var-file terraform.tfvars
```
