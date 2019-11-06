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

variable "platform" {
  description = "Platform to target"
  default     = "linux"
}

variable "bq_path" {
  description = "Path to bq CLI; Defaults to `bq`"
  default     = "bq"
}

variable "project" {
  description = "Project ID of dataset to add permissions to"
}

variable "dataset_id" {
  description = "Dataset ID of dataset to add permissions to"
}

variable "preserve_special_groups" {
  description = "Preserve special group permissions. Defaults to true."
  default     = "true"
}

variable "roles_json" {
  default     = "[]"
  description = <<EOF
JSON structure is an list of maps using the same keys and structure as the [`bq CLI`](https://cloud.google.com/bigquery/docs/bq-command-line-tool).

A role ACL entry must have the key `role` with a value of `OWNER`, `READER`, or `WRITER` and one of the following keys: `userByEmail`, `domain`, or `groupByEmail`.

```
[
  {
    "role": "OWNER",
    "userByEmail": "admin@foo.com"
  },
  {
    "role": "READER",
    "domain": "foo.com"
  },
  {
    "role": "WRITER",
    "groupByEmail": "editors@foo.com"
  }
]
```
EOF

}

variable "roles" {
  default     = []
  type        = list(map(string))
  description = "List of roles in HCL. Overrides roles_json. Keys must be in camelCase format."
}

variable "views" {
  default     = []
  type        = list(map(string))
  description = "List of view permissions. Each entry must consist of `project`, `dataset`, and `table` receiving access."
}

