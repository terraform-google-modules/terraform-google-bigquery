# terraform-google-bigquery

This module allows you to create opinionated Google Cloud Platform BigQuery datasets and tables.
This will allow the user to programmatically create an empty table schema inside of a dataset, ready for loading.
Additional user accounts and permissions are necessary to begin querying the newly created table(s).

## Upgrading

The current version is 1.X. The following guide is available to assist with upgrades:

- [0.1 -> 1.0](./docs/upgrading_to_bigquery_v1.0.md)

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
| project_id | Project where the dataset and table are created | string | yes ||
| tables  | A list of maps containing table_id and schema files | array | yes ||
| table_id  | A attribute in the map of the tables list, that contains a unique id for the table being provisioned | string | yes ||
| time_partitioning | Unique id for the table being provisioned | string | yes ||
| schema | A attribute in the map of the tables list, that contains JSON schema files for the table | string | yes ||

## Outputs
| Name | Description |
|------|-------------|
| dataset_id | Unique id for the dataset being provisioned |
| dataset_name | Friendly name for the dataset being provisioned |
| dataset_project | Project wheree the dataset and table are created |
| table_id | List of unique id for the table(s) being provisioned |
| table_name | List friendly name(s) for the dataset being provisioned |
| dataset_labels | Key value pairs in a map for dataset labels |
| table_labels | Key value pairs in a map for table labels |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v2.5.0

### Permissions
In order to execute this module you must have a Service Account with the following roles:
 - roles/bigquery.dataOwner

#### Script Helper
A helper script for configuring a Service Account is located at (./helpers/setup-sa.sh).

## Install
### Terraform
Be sure you have the current Terraform version (0.12.x), you can choose the binary from [Terraform releases](https://releases.hashicorp.com/terraform/).

### kitchen-terraform
To set this up on your machine, follow the official [Kitchen installation](https://github.com/newcontext-oss/kitchen-terraform) instructions.
- Kitchen tests are located: [test/integration/full](test/integration/full).
- Terraform fixtures are located: [test/fixtures/full](test/fixtures/full).

## Running tests
`cd /path/to/terraform-google-bigquery`
The following command will run all tests for the module:
`make`

### macOS mojave notes
To run kitchen tests on macOS > 10.14.4 xcode will need to be [reset](https://apple.stackexchange.com/questions/254380/why-am-i-getting-an-invalid-active-developer-path-when-attempting-to-use-git-a)
`xcode-select --install`
