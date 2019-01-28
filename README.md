# terraform-google-bigquery

This module allows you to create opinionated Google Cloud Platform Big Query datasets and tables.

## Usage
There are multiple examples in the [examples](./examples/) folder.

## Features
Module provides a example for deploying a single dataset and a table onside of the dataset with an example schema.

## Inputs
| Name | Description | Type | Required | Default |
|------|-------------|:----:|:-----:|:-----:|
| dataset_id | Unique id for the dataset being provisioned | string| yes ||
| dataset_name | Friendly name for the dataset being provisioned | string | yes ||
| description | Dataset description | string | yes |  ||
| region | The regional location for the dataset only US and EU are allowed in module | string | yes | US ||
| expiration | TTL of tables using the dataset in MS | integer | yes ||
| project_id | Project wheree the dataset and table are created | string | yes ||
| table_id  | Unique id for the table being provisioned | string | yes ||
| time_partitioning | Unique id for the table being provisioned | string | yes ||
| schema_file | A JSON schema for the table | string | yes ||

## Outputs
| Name | Description |
|------|-------------|
| dataset_id | Unique id for the dataset being provisioned |
| dataset_name | Friendly name for the dataset being provisioned |
| dataset_project | Project wheree the dataset and table are created |
| table_id | Unique id for the table being provisioned |
| dataset_labels | Key value pairs in a map for dataset labels |
| table_labels | Key value pairs in a map for table labels |

## File structure
The project has the following folders and files:
```bash
.
├── docs                   # folder is the landing location for troubleshooting docs
├── examples               # example deployments of the module
├── helpers                # optional scripts to setup required packages, gcp services, etc
├── test                   # kitchen fixtures, boilerplate & integration tests
├── .kitchen.yml           # establishing the kitchen root
├── config.tf              # terraform providers & Requirements
├── Gemfile                # Gemfile containing reqired Gems for running kitchen-terraform
├── Gemfile.lock           # Locked gem versions
├── main.tf                # terraform module
├── Makefile               # enables make to setup local environment
├── outputs.tf             # module outputs
├── variables.tf           # variables that can be consumed by the module           
├── LICENSE
└── README.md
```
## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.11.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0
- [terraform-provider-gsuite](https://github.com/DeviaVir/terraform-provider-gsuite) plugin if GSuite functionality is desired

### Permissions
In order to execute this module you must have a Service Account with the following roles:
 - roles/bigquery.dataOwner

#### Script Helper
.helpers/setup-sa.sh


## Install
### Terraform
Be sure you have the correct Terraform version (0.11.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/
- test directory holds all integration tests and will require

### kitchen-terraform
Follow installation instructions for your mac osx
- https://github.com/newcontext-oss/kitchen-terraform
- kitchen tests are located: [test/integration/full](test/integration/full)
- terraform test deployment scripts are located: [test/fixtures/full](test/fixtures/full) if there are tests added or if the module is changed these files will need updated

## Running tests

`cd /path/to/terraform-good-bigquery`
`make` #this will run all tests that were created for this module. as a result you can run the tests found in this file individually if desired
