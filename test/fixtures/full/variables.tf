/**
 * Copyright 2019 Google LLC
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

variable "default_table_expiration_ms" {
  description = "Default TTL of tables using the dataset in MS"
  default     = 3600000
}

variable "project_id" {
  description = "Project where the dataset and table are created"
}

variable "dataset_labels" {
  description = "Key value pairs in a map for dataset labels"
  type        = map(string)
  default = {
    env      = "dev"
    billable = "true"
    owner    = "janesmith"
  }
}

variable "tables" {
  description = "A list of maps that includes table_id, schema, clustering, time_partitioning, expiration_time, labels in each element"
  default = [
    {
      table_id = "foo",
      schema   = "sample_bq_schema.json",
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      expiration_time = null,
      clustering      = ["fullVisitorId", "visitId"],
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
      view = null,
    },
    {
      table_id          = "bar",
      schema            = "sample_bq_schema.json",
      time_partitioning = null,
      expiration_time   = 2524604400000, # 2050/01/01
      clustering        = [],
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      },
      view = null
    },
    {
      table_id          = "test_view",
      schema            = null,
      time_partitioning = null,
      expiration_time   = 2524604400000, # 2050/01/01
      clustering        = [],
      labels            = {},
      view = {
        query          = "select visitNumber from foo.bar limit 100"
        use_legacy_sql = true
      }

    }
  ]
  type = list(object({
    table_id   = string,
    schema     = string,
    clustering = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    expiration_time = string,
    view = object({
      query          = string,
      use_legacy_sql = bool,
    }),
    labels = map(string),
  }))
}
