# terraform-google-bigquery

This module allows you to create opinionated Google Cloud Platform Big Query datasets and tables.

## Usage
Examples of how to use this module are located in the [examples directory](./examples)

## Features
This module provisions a dataset and a table with an associated JSON schema.

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
To set this up on your machine, follow the official [Kitchen installation](https://github.com/newcontext-oss/kitchen-terraform) instructions.
- Kitchen tests are located: [test/integration/full](test/integration/full).
- Terraform fixtures are located: [test/fixtures/full](test/fixtures/full).

## Running tests

`cd /path/to/terraform-google-bigquery`
The following command will run all tests for the module:
`make`
