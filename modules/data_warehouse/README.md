# terraform-google-bigquery-data-warehouse

## Description
This module provides an example of a data warehouse deployed using Google Cloud and BigQuery.

### Details

The resources/services/activations/deletions that this module will create/trigger are:

- Creates a BigQuery Dataset
- Creates a BigQuery Table
- Creates a Google Cloud Storage bucket
- Loads the Google Cloud Storage bucket with data from https://console.cloud.google.com/marketplace/product/city-of-new-york/nyc-tlc-trips
- Provides SQL examples
- Creates and inferences with a BigQuery ML model
- Creates a Looker Studio report

### preDeploy
To deploy this blueprint you must have an active billing account and billing permissions.

## Documentation
- [Create a Data Warehouse](https://cloud.google.com/architecture/big-data-analytics/data-warehouse)
- [Learn about BigQuery](https://cloud.google.com/bigquery/docs/introduction)

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
| lookerstudio\_report\_url | The URL to create a new Looker Studio report displays a sample dashboard for the taxi data analysis |
| neos\_tutorial\_url | The URL to launch the in-console tutorial for the EDW solution |
| raw\_bucket | Raw bucket name |

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
- BigQuery Admin: `roles/bigquery.admin`
- Workflows Admin: `roles/workflows.admin`
- Eventarc Admin: `roles/eventarc.admin`
- Pub/Sub Admin: `roles/pubsub.admin`
- Dataplex Admin: `roles/dataplex.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- BigQuery API: `bigquery.googleapis.com`
- BigQuery Migration API: `bigquerymigration.googleapis.com`
- BigQuery Storage API: `bigquerystorage.googleapis.com`
- BigQuery Connection API: `bigqueryconnection.googleapis.com`
- BigQuery Reservations API: `bigqueryreservation.googleapis.com`
- BigQuery Data Transfer Service API: `bigquerydatatransfer.googleapis.com`
- Data Catalog API: `datacatalog.googleapis.com`
- Data Lineage API: `datalineage.googleapis.com`
- Eventarc API: `eventarc.googleapis.com`
- Google Cloud Pub/Sub API: `pubsub.googleapis.com`
- Service Usage API: `serviceusage.googleapis.com`
- Google Cloud Storage API: `storage.googleapis.com`
- Google Cloud Storage JSON API: `storage-api.googleapis.com`
- Google Cloud Workflows API: `workflows.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.


## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
