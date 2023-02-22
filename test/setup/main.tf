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

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name                    = "ci-bigquery"
  random_project_id       = "true"
  org_id                  = var.org_id
  folder_id               = var.folder_id
  billing_account         = var.billing_account
  default_service_account = "keep"

  activate_apis = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
  ]
}

module "kms_keyring" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.0"

  project_id      = module.project.project_id
  location        = "us"
  keyring         = "ci-bigquery-keyring"
  keys            = ["foo"]
  prevent_destroy = "false"
  depends_on = [
    module.project
  ]
}

data "google_bigquery_default_service_account" "initialize_encryption_account" {
  project = module.project.project_id
}
