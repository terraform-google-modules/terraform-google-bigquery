# terraform-google-bigquery multiple_tables
The multiple_tables example uses the root terraform-google-bigquery module
to deploy a single dataset and two tables with basic schemas.
This example is a good reference to understand and test the module usage.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dataset\_labels | A mapping of labels to assign to the table. | `map(string)` | n/a | yes |
| default\_table\_expiration\_ms | Default TTL of tables using the dataset in MS. | `any` | `null` | no |
| delete\_contents\_on\_destroy | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `null` | no |
| external\_tables | A list of objects which include table\_id, expiration\_time, external\_data\_configuration, and labels. | <pre>list(object({<br>    table_id              = string,<br>    autodetect            = bool,<br>    compression           = string,<br>    ignore_unknown_values = bool,<br>    max_bad_records       = number,<br>    schema                = string,<br>    source_format         = string,<br>    source_uris           = list(string),<br>    csv_options = object({<br>      quote                 = string,<br>      allow_jagged_rows     = bool,<br>      allow_quoted_newlines = bool,<br>      encoding              = string,<br>      field_delimiter       = string,<br>      skip_leading_rows     = number,<br>    }),<br>    google_sheets_options = object({<br>      range             = string,<br>      skip_leading_rows = number,<br>    }),<br>    hive_partitioning_options = object({<br>      mode              = string,<br>      source_uri_prefix = string,<br>    }),<br>    expiration_time = string,<br>    labels          = map(string),<br>  }))</pre> | `[]` | no |
| kms\_key | The KMS key to use to encrypt data by default | `string` | `null` | no |
| project\_id | Project where the dataset and table are created. | `any` | n/a | yes |
| tables | A list of maps that includes table\_id, schema, clustering, time\_partitioning, expiration\_time, labels in each element. | <pre>list(object({<br>    table_id   = string,<br>    schema     = string,<br>    clustering = list(string),<br>    time_partitioning = object({<br>      expiration_ms            = string,<br>      field                    = string,<br>      type                     = string,<br>      require_partition_filter = bool,<br>    }),<br>    expiration_time = string,<br>    labels          = map(string),<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| bigquery\_dataset | Bigquery dataset resource. |
| bigquery\_external\_tables | Map of bigquery table resources being provisioned. |
| bigquery\_tables | Map of bigquery table resources being provisioned. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Setup
Update the contents of `terraform.tfvars` to match your test environment.

## Run example
`terraform init`
`terraform plan`
`terraform apply -var-file terraform.tfvars`
