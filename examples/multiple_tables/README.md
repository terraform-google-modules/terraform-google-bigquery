# terraform-google-bigquery multiple_tables
The multiple_tables example uses the root terraform-google-bigquery module
to deploy a single dataset and two tables with basic schemas.
This example is a good reference to understand and test the module usage.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dataset\_labels | A mapping of labels to assign to the table | map(string) | n/a | yes |
| expiration | TTL of tables using the dataset in MS | string | `"3600000"` | no |
| project\_id | Project wheree the dataset and table are created | string | n/a | yes |
| tables | A list of maps that includes both table_id and schema in each element, the table(s) will be created on the single dataset | object | `<list>` | no |
| time\_partitioning | Configures time-based partitioning for this table | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dataset\_id | Unique id for the dataset being provisioned |
| dataset\_labels | Key value pairs in a map for dataset labels |
| dataset\_name | Friendly name for the dataset being provisioned |
| dataset\_project | Project where the dataset and table are created |
| table\_id | Unique id for the table being provisioned |
| table\_labels | Key value pairs in a map for table labels |
| table\_name | Friendly name for the table being provisioned |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Setup
Update the contents of `terraform.tfvars` to match your test environment.

## Run example
`terraform init`
`terraform plan`
`terraform apply -var-file terraform.tfvars`