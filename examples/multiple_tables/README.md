# terraform-google-bigquery multiple_tables
The multiple_tables example uses the root terraform-google-bigquery module to deploy a single dataset and a table with a basic schema. This example is a good reference to understand and test the module usage.

## Setup
Update the contents of `terraform.tfvars` to match your test environment.

## Run example
`terraform init`
`terraform plan`
`terraform apply -var-file terraform.tfvars`
