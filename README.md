Copyright 2023 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.42, < 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_routine.routine](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_routine) | resource |
| [google_bigquery_table.external_table](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_bigquery_table.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_bigquery_table.materialized_view](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_bigquery_table.view](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | An array of objects that define dataset access for one or more entities. | `any` | <pre>[<br>  {<br>    "role": "roles/bigquery.dataOwner",<br>    "special_group": "projectOwners"<br>  }<br>]</pre> | no |
| <a name="input_dataset_id"></a> [dataset\_id](#input\_dataset\_id) | Unique ID for the dataset being provisioned. | `string` | n/a | yes |
| <a name="input_dataset_labels"></a> [dataset\_labels](#input\_dataset\_labels) | Key value pairs in a map for dataset labels | `map(string)` | `{}` | no |
| <a name="input_dataset_name"></a> [dataset\_name](#input\_dataset\_name) | Friendly name for the dataset being provisioned. | `string` | `null` | no |
| <a name="input_default_table_expiration_ms"></a> [default\_table\_expiration\_ms](#input\_default\_table\_expiration\_ms) | TTL of tables using the dataset in MS | `number` | `null` | no |
| <a name="input_delete_contents_on_destroy"></a> [delete\_contents\_on\_destroy](#input\_delete\_contents\_on\_destroy) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether or not to allow deletion of tables and external tables defined by this module. Can be overriden by table-level deletion\_protection configuration. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Dataset description. | `string` | `null` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | Default encryption key to apply to the dataset. Defaults to null (Google-managed). | `string` | `null` | no |
| <a name="input_external_tables"></a> [external\_tables](#input\_external\_tables) | A list of objects which include table\_id, expiration\_time, external\_data\_configuration, and labels. | <pre>list(object({<br>    table_id              = string,<br>    description           = optional(string),<br>    autodetect            = bool,<br>    compression           = string,<br>    ignore_unknown_values = bool,<br>    max_bad_records       = number,<br>    schema                = string,<br>    source_format         = string,<br>    source_uris           = list(string),<br>    csv_options = object({<br>      quote                 = string,<br>      allow_jagged_rows     = bool,<br>      allow_quoted_newlines = bool,<br>      encoding              = string,<br>      field_delimiter       = string,<br>      skip_leading_rows     = number,<br>    }),<br>    google_sheets_options = object({<br>      range             = string,<br>      skip_leading_rows = number,<br>    }),<br>    hive_partitioning_options = object({<br>      mode              = string,<br>      source_uri_prefix = string,<br>    }),<br>    expiration_time     = string,<br>    max_staleness       = optional(string),<br>    deletion_protection = optional(bool),<br>    labels              = map(string),<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The regional location for the dataset only US and EU are allowed in module | `string` | `"US"` | no |
| <a name="input_materialized_views"></a> [materialized\_views](#input\_materialized\_views) | A list of objects which includes view\_id, view\_query, clustering, time\_partitioning, range\_partitioning, expiration\_time and labels | <pre>list(object({<br>    view_id                  = string,<br>    description              = optional(string),<br>    query                    = string,<br>    enable_refresh           = bool,<br>    refresh_interval_ms      = string,<br>    clustering               = list(string),<br>    require_partition_filter = bool,<br>    time_partitioning = object({<br>      expiration_ms = string,<br>      field         = string,<br>      type          = string,<br>    }),<br>    range_partitioning = object({<br>      field = string,<br>      range = object({<br>        start    = string,<br>        end      = string,<br>        interval = string,<br>      }),<br>    }),<br>    expiration_time = string,<br>    max_staleness   = optional(string),<br>    labels          = map(string),<br>  }))</pre> | `[]` | no |
| <a name="input_max_time_travel_hours"></a> [max\_time\_travel\_hours](#input\_max\_time\_travel\_hours) | Defines the time travel window in hours | `number` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where the dataset and table are created | `string` | n/a | yes |
| <a name="input_routines"></a> [routines](#input\_routines) | A list of objects which include routine\_id, routine\_type, routine\_language, definition\_body, return\_type, routine\_description and arguments. | <pre>list(object({<br>    routine_id      = string,<br>    routine_type    = string,<br>    language        = string,<br>    definition_body = string,<br>    return_type     = string,<br>    description     = string,<br>    arguments = list(object({<br>      name          = string,<br>      data_type     = string,<br>      argument_kind = string,<br>      mode          = string,<br>    })),<br>  }))</pre> | `[]` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | A list of objects which include table\_id, table\_name, schema, clustering, time\_partitioning, range\_partitioning, expiration\_time and labels. | <pre>list(object({<br>    table_id                 = string,<br>    description              = optional(string),<br>    table_name               = optional(string),<br>    schema                   = string,<br>    clustering               = list(string),<br>    require_partition_filter = bool,<br>    time_partitioning = object({<br>      expiration_ms = string,<br>      field         = string,<br>      type          = string,<br>    }),<br>    range_partitioning = object({<br>      field = string,<br>      range = object({<br>        start    = string,<br>        end      = string,<br>        interval = string,<br>      }),<br>    }),<br>    expiration_time     = string,<br>    deletion_protection = optional(bool),<br>    labels              = map(string),<br>  }))</pre> | `[]` | no |
| <a name="input_views"></a> [views](#input\_views) | A list of objects which include view\_id and view query | <pre>list(object({<br>    view_id        = string,<br>    description    = optional(string),<br>    query          = string,<br>    use_legacy_sql = bool,<br>    labels         = map(string),<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bigquery_dataset"></a> [bigquery\_dataset](#output\_bigquery\_dataset) | Bigquery dataset resource. |
| <a name="output_bigquery_external_tables"></a> [bigquery\_external\_tables](#output\_bigquery\_external\_tables) | Map of BigQuery external table resources being provisioned. |
| <a name="output_bigquery_tables"></a> [bigquery\_tables](#output\_bigquery\_tables) | Map of bigquery table resources being provisioned. |
| <a name="output_bigquery_views"></a> [bigquery\_views](#output\_bigquery\_views) | Map of bigquery view resources being provisioned. |
| <a name="output_external_table_ids"></a> [external\_table\_ids](#output\_external\_table\_ids) | Unique IDs for any external tables being provisioned |
| <a name="output_external_table_names"></a> [external\_table\_names](#output\_external\_table\_names) | Friendly names for any external tables being provisioned |
| <a name="output_project"></a> [project](#output\_project) | Project where the dataset and tables are created |
| <a name="output_routine_ids"></a> [routine\_ids](#output\_routine\_ids) | Unique IDs for any routine being provisioned |
| <a name="output_table_ids"></a> [table\_ids](#output\_table\_ids) | Unique id for the table being provisioned |
| <a name="output_table_names"></a> [table\_names](#output\_table\_names) | Friendly name for the table being provisioned |
| <a name="output_view_ids"></a> [view\_ids](#output\_view\_ids) | Unique id for the view being provisioned |
| <a name="output_view_names"></a> [view\_names](#output\_view\_names) | friendlyname for the view being provisioned |
