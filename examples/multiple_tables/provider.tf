/**
 * Copyright 2022 Google LLC
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

provider "google" {
  scopes = [
    # To configure an external table with a Google Sheet you must pass this scope
    # see: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table#source_format
    "https://www.googleapis.com/auth/drive.readonly",
    # Because we are using scopes, you must also give it the BigQuery scope
    "https://www.googleapis.com/auth/bigquery",
  ]
}
