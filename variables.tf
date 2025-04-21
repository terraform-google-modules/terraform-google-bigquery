/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
}

variable "dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = null
}

variable "description" {
  description = "Dataset description."
  type        = string
  default     = null
}

variable "location" {
  description = "The location of the dataset. For multi-region, US or EU can be provided."
  type        = string
  default     = "US"
}

variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = null
}

variable "deletion_protection" {
  description = "Whether or not to allow deletion of tables and external tables defined by this module. Can be overriden by table-level deletion_protection configuration."
  type        = bool
  default     = false
}

variable "default_table_expiration_ms" {
  description = "TTL of tables using the dataset in MS"
  type        = number
  default     = null
}

variable "default_partition_expiration_ms" {
  description = "The default partition expiration for all partitioned tables in the dataset, in MS"
  type        = number
  default     = null
}

variable "max_time_travel_hours" {
  description = "Defines the time travel window in hours"
  type        = number
  default     = null
}

variable "storage_billing_model" {
  description = "Specifies the storage billing model for the dataset. Set this flag value to LOGICAL to use logical bytes for storage billing, or to PHYSICAL to use physical bytes instead. LOGICAL is the default if this flag isn't specified."
  type        = string
  default     = null

  validation {
    condition     = var.storage_billing_model == null || var.storage_billing_model == "LOGICAL" || var.storage_billing_model == "PHYSICAL"
    error_message = "storage_billing_model must be null, \"LOGICAL\" or \"PHYSICAL\"."
  }
}

variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}

variable "encryption_key" {
  description = "Default encryption key to apply to the dataset. Defaults to null (Google-managed)."
  type        = string
  default     = null
}

variable "dataset_labels" {
  description = "Key value pairs in a map for dataset labels"
  type        = map(string)
  default     = {}
}

variable "resource_tags" {
  description = "A map of resource tags to add to the dataset"
  type        = map(string)
  default     = {}
}

# Format: list(objects)
# domain: A domain to grant access to.
# group_by_email: An email address of a Google Group to grant access to.
# user_by_email:  An email address of a user to grant access to.
# special_group: A special group to grant access to.
variable "access" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any

  # At least one owner access is required.
  default = [{
    role          = "roles/bigquery.dataOwner"
    special_group = "projectOwners"
  }]
}

variable "tables" {
  description = "A list of objects which include table_id, table_name, schema, clustering, table_constraints, time_partitioning, range_partitioning, expiration_time, and labels."
  type = list(object({
    table_id    = string
    description = optional(string)
    table_name  = optional(string)
    schema      = string
    clustering  = list(string)
    table_constraints = optional(object({
      primary_key = optional(object({
        columns = list(string)
      }))
      foreign_keys = optional(list(object({
        name = string
        referenced_table = object({
          project_id = string
          dataset_id = string
          table_id   = string
        })
        column_references = list(object({
          referencing_column = string
          referenced_column  = string
        }))
      })))
    }))
    time_partitioning = object({
      expiration_ms = string
      field         = string
    })
    range_partitioning = optional(object({
      field = string
      range = object({
        start    = string
        end      = string
        interval = string
      })
    }))
    expiration_time = optional(string)
    labels          = optional(map(string))
  }))
  default = []
}

variable "views" {
  description = "A list of objects which include view_id and view query"
  default     = []
  type = list(object({
    view_id        = string,
    description    = optional(string),
    query          = string,
    use_legacy_sql = bool,
    labels         = optional(map(string), {}),
  }))
}

variable "materialized_views" {
  description = "A list of objects which includes view_id, view_query, clustering, time_partitioning, range_partitioning, expiration_time and labels"
  default     = []
  type = list(object({
    view_id             = string,
    description         = optional(string),
    query               = string,
    enable_refresh      = bool,
    refresh_interval_ms = string,
    clustering          = optional(list(string), []),
    time_partitioning = optional(object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }), null),
    range_partitioning = optional(object({
      field = string,
      range = object({
        start    = string,
        end      = string,
        interval = string,
      }),
    }), null),
    expiration_time = optional(string, null),
    max_staleness   = optional(string),
    labels          = optional(map(string), {}),
  }))
}

variable "external_tables" {
  description = "A list of objects which include table_id, expiration_time, external_data_configuration, and labels."
  default     = []
  type = list(object({
    table_id              = string,
    description           = optional(string),
    autodetect            = bool,
    compression           = string,
    ignore_unknown_values = bool,
    max_bad_records       = number,
    schema                = string,
    source_format         = string,
    source_uris           = list(string),
    csv_options = object({
      quote                 = string,
      allow_jagged_rows     = bool,
      allow_quoted_newlines = bool,
      encoding              = string,
      field_delimiter       = string,
      skip_leading_rows     = number,
    }),
    google_sheets_options = object({
      range             = string,
      skip_leading_rows = number,
    }),
    hive_partitioning_options = object({
      mode              = string,
      source_uri_prefix = string,
    }),
    expiration_time     = optional(string, null),
    max_staleness       = optional(string),
    deletion_protection = optional(bool),
    labels              = optional(map(string), {}),
  }))
}


variable "routines" {
  description = "A list of objects which include routine_id, routine_type, routine_language, definition_body, return_type, routine_description and arguments."
  default     = []
  type = list(object({
    routine_id      = string,
    routine_type    = string,
    language        = string,
    definition_body = string,
    return_type     = string,
    description     = string,
    arguments = optional(list(object({
      name          = string,
      data_type     = string,
      argument_kind = string,
      mode          = string,
    })), []),
  }))
}
