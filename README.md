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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dataset\_id | Unique ID for the dataset being provisioned | string | n/a | yes |
| dataset\_labels | Key value pairs in a map for dataset labels | map(string) | n/a | yes |
| dataset\_name | Friendly name for the dataset being provisioned | string | n/a | yes |
| description | Dataset description | string | n/a | yes |
| expiration | TTL of tables using the dataset in MS | string | `"3600000"` | no |
| location | The regional location for the dataset only US and EU are allowed in module | string | `"US"` | no |
| project\_id | Project wheree the dataset and table are created | string | n/a | yes |
| tables | A list of objects which include table_id, schema, and labels. | object | `<list>` | no |
| time\_partitioning | Configures time-based partitioning for this table | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dataset\_id | Unique id for the dataset being provisioned |
| dataset\_labels | Key value pairs in a map for dataset labels |
| dataset\_name | Friendly name for the dataset being provisioned |
| dataset\_project | Project wheree the dataset and table are created |
| table\_id | Unique id for the table being provisioned |
| table\_labels | Key value pairs in a map for table labels |
| table\_name | Friendly name for the table being provisioned |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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
