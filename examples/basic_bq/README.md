# terraform-google-bigquery basic_bq

## Setup
- Update the variable values in terraform.tfvars.example to match your test environment
- Rename tfvars file `mv terraform.tfvars.example terraform.tfvars`

## Run example
`cd ./examples/basic_bq`
`terraform init`
`terraform plan -var-file example.tfvars`
`terraform apply -var-file example.tfvars`
