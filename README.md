# terraform-google-bigquery

This module allows you to create opinionated Google Cloud Platform Big Query datasets and tables.

## Usage
There are multiple examples in the [examples](./examples/) folder

## Features

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dataset_id | | string| | yes |
| dataset_name | | string | | yes |
| description | | string | | yes |
| region | | string | US | yes |
| expiration | | integer | | yes |
| project_id | | string | | |
| table_id  | | string | | |
| time_partitioning  | | string | | |
| schema_file  | | string | | |

## Outputs
| Name | Description |
|------|-------------|

## File structure
The project has the following folders and files

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.11.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0
- [terraform-provider-gsuite](https://github.com/DeviaVir/terraform-provider-gsuite) plugin if GSuite functionality is desired

### Permissions
In order to execute this module you must have a Service Account with the following roles:

#### Script Helper


## Install
### Terraform
Be sure you have the correct Terraform version (0.11.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## TODO
* modify test/integration/gcloud/integration.bats
* Verify all tests in test/
* Update the service account permissions required
* Update helpers/setup-sa.sh
* DONE: Create the TF module
* DONE: Provide an example/
* Add the scripts directory
* update README.md
* DONE: Create/update outputs.tf
