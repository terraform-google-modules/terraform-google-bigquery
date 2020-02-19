# terraform-google-bigquery

This module allows you to create opinionated Google Cloud Platform BigQuery datasets and tables.
This will allow the user to programmatically create an empty table schema inside of a dataset, ready for loading.
Additional user accounts and permissions are necessary to begin querying the newly created table(s).

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-12.html) and need a Terraform 0.11.x-compatible version of this module,
the last released version intended for Terraform 0.11.x is [1.0.0](https://registry.terraform.io/modules/terraform-google-modules/bigquery/google/1.0.0).

## Upgrading

The current version is 3.X. The following guides are available to assist with upgrades:

- [2.0 -> 3.0](./docs/upgrading_to_bigquery_v3.0.md)
- [1.0 -> 2.0](./docs/upgrading_to_bigquery_v2.0.md)
- [0.1 -> 1.0](./docs/upgrading_to_bigquery_v1.0.md)

## Usage

Basic usage of this module is as follows:

```hcl
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 4.0"

  dataset_id                  = "foo"
  dataset_name                = "foo"
  description                 = "some description"
  project_id                  = "<PROJECT ID>"
  location                    = "US"
  default_table_expiration_ms = 3600000

  tables = [
  {
    table_id          = "foo",
    schema            =  "<PATH TO THE SCHEMA JSON FILE>",
    time_partitioning = {
      type                     = "DAY",
      field                    = null,
      require_partition_filter = false,
      expiration_ms            = null,
    },
    expiration_time = null,
    clustering      = ["fullVisitorId", "visitId"],
    labels          = {
      env      = "dev"
      billable = "true"
      owner    = "joedoe"
    },
  },
  {
    table_id          = "bar",
    schema            =  "<PATH TO THE SCHEMA JSON FILE>",
    time_partitioning = null,
    expiration_time   = 2524604400000, # 2050/01/01
    clustering        = [],
    labels = {
      env      = "devops"
      billable = "true"
      owner    = "joedoe"
    }
  ]
  dataset_labels = {
    env      = "dev"
    billable = "true"
  }
}
```

Functional examples are included in the
[examples](./examples/) directory.

### Variable `tables` detailed description

The `tables` variable should be provided as a list of object with the following keys:
```hcl
{
  table_id = "some_id"                        # Unique table id (will be used as ID and Freandly name for the table).
  schema = "path/to/schema.json"              # Path to the schema json file.
  time_partitioning = {                       # Set it to `null` to omit partitioning configuration for the table.
        type                     = "DAY",     # The only type supported is DAY, which will generate one partition per day based on data loading time.
        field                    = null,      # The field used to determine how to create a time-based partition. If time-based partitioning is enabled without this value, the table is partitioned based on the load time. Set it to `null` to omit configuration.
        require_partition_filter = false,     # If set to true, queries over this table require a partition filter that can be used for partition elimination to be specified. Set it to `null` to omit configuration.
        expiration_ms            = null,      # Number of milliseconds for which to keep the storage for a partition.
      },
  clustering = ["fullVisitorId", "visitId"]   # Specifies column names to use for data clustering. Up to four top-level columns are allowed, and should be specified in descending priority order. Partitioning should be configured in order to use clustering.
  expiration_time = 2524604400000             # The time when this table expires, in milliseconds since the epoch. If set to `null`, the table will persist indefinitely.
  dataset_labels = {                          # A mapping of labels to assign to the table.
      env      = "dev"
      billable = "true"
    }
}
```

## Features
This module provisions a dataset and a list of tables with associated JSON schemas.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access | An array of objects that define dataset access for one or more entities. | any | `<list>` | no |
| dataset\_id | Unique ID for the dataset being provisioned. | string | n/a | yes |
| dataset\_labels | Key value pairs in a map for dataset labels | map(string) | `<map>` | no |
| dataset\_name | Friendly name for the dataset being provisioned. | string | `"null"` | no |
| default\_table\_expiration\_ms | TTL of tables using the dataset in MS | number | `"null"` | no |
| description | Dataset description. | string | `"null"` | no |
| location | The regional location for the dataset only US and EU are allowed in module | string | `"US"` | no |
| project\_id | Project where the dataset and table are created | string | n/a | yes |
| tables | A list of objects which include table_id, schema, clustering, time_partitioning, expiration_time and labels. | object | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_dataset | Bigquery dataset resource. |
| bigquery\_tables | Map of bigquery table resources being provisioned. |
| project | Project where the dataset and tables are created |
| table\_ids | Unique id for the table being provisioned |
| table\_names | Unique id for the table being provisioned |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.15

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- BigQuery Data Owner: `roles/bigquery.dataOwner`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

#### Script Helper
A helper script for configuring a Service Account is located at (./helpers/setup-sa.sh).

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- BigQuery JSON API: `bigquery-json.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
