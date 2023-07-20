# terraform-google-bigquery scheduled_queries

This example illustrates how to create scheduled queries using `scheduled_queries` module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project where scheduled queries are created | `string` | n/a | yes |
| queries | Data transfer configuration for creating scheduled queries | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| query\_names | The resource names of the transfer config |

## Usage

Run the following commands within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| query\_names | The resource names of the transfer config |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
