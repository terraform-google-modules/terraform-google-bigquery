# terraform-google-ssw

## Description
### tagline
This is an auto-generated module.

### detailed

The resources/services/activations/deletions that this module will create/trigger are:

- Creates a BQ Dataset
- Creates a BQ Table
- Creates a GCS bucket
- Loads the GCS bucket with data from https://pantheon.corp.google.com/marketplace/product/city-of-new-york/nyc-tlc-trips
- Provides SQL examples
- Creates and inferences with a BigQuery ML model
- Creates a datastudio report

### preDeploy
To deploy this blueprint you must have an active billing account and billing permissions.

## Documentation
- [Hosting a Static Website](https://cloud.google.com/storage/docs/hosting-static-website)

## Usage

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deletion\_protection | Whether or not to protect GCS resources from deletion when solution is modified or changed. | `string` | `true` | no |
| enable\_apis | Whether or not to enable underlying apis in this solution. | `string` | `true` | no |
| force\_destroy | Whether or not to protect BigQuery resources from deletion when solution is modified or changed. | `string` | `false` | no |
| labels | A map of labels to apply to contained resources. | `map(string)` | <pre>{<br>  "edw-bigquery": true<br>}</pre> | no |
| project\_id | Google Cloud Project ID | `string` | n/a | yes |
| region | Google Cloud Region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_editor\_url | The URL to launch the BigQuery editor with the sample query procedure opened |
| ds\_friendly\_name | Dataset name |
| function\_uri | Function URI |
| lookerstudio\_report\_url | The URL to create a new Looker Studio report displays a sample dashboard for the taxi data analysis |
| neos\_tutorial\_url | The URL to launch the in-console tutorial for the EDW solution |
| raw\_bucket | Raw bucket name |
| solution\_guide\_url | The URL to Solution Guide for the EDW solution |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.


## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
