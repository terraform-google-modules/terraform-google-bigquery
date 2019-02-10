# terraform-google-bigquery

This module allows you to create opinionated Google Cloud Platform Big Query datasets and tables.

## Usage
The root module can be used to provision a dataset and a table with a json schema associated with the table. There are multiple examples in the [examples](./examples/) folder.

## Features
Module provides a example for deploying a single dataset and a table onside of the dataset with an example schema.

[^]: (autogen_docs_start)

## Inputs
| Name | Description | Type | Required | Default |
|------|-------------|:----:|:-----:|:-----:|
| dataset_id | Unique id for the dataset being provisioned | string| yes ||
| dataset_name | Friendly name for the dataset being provisioned | string | yes ||
| description | Dataset description | string | yes |  ||
| location | The regional location for the dataset, all Big Query [dataset locations](https://cloud.google.com/bigquery/docs/locations) are allows | string | yes | US ||
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

[^]: (autogen_docs_end)

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
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.20.0

### Permissions
In order to execute this module you must have a Service Account with the following roles:
 - roles/bigquery.dataOwner

#### Script Helper
A helper script for configuring a Service Account is located at (./helpers/setup-sa.sh).

## Install
### Terraform
Be sure you have the correct Terraform version (0.11.x), you can choose the binary from [Terraform releases](https://releases.hashicorp.com/terraform/).

### kitchen-terraform
Tests verified on mac osx, to set this up on your machine follow the official [Kitchen installation](https://github.com/newcontext-oss/kitchen-terraform) instructions.
- Kitchen tests are located: [test/integration/full](test/integration/full).
- Terraform fixtures are located: [test/fixtures/full](test/fixtures/full).

## Running tests

`cd /path/to/terraform-google-bigquery`
The following command will run all tests for the module:
`make`
