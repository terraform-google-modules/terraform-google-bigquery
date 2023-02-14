# Simple Example

This example illustrates how to use the `data_warehouse` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | The region and data locatoin to create the resources in. | `string` | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lookerstudio_report_url | The URL of the Looker Studio report to open. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
