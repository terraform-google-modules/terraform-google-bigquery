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

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 9.0"

  name                 = "ci-bigquery"
  random_project_id    = "true"
  org_id               = var.org_id
  folder_id            = var.folder_id
  billing_account      = var.billing_account
  skip_gcloud_download = true

  activate_apis = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerystorage.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

#Can't delete this with Terraform.
module "kms_keyring" {
  source     = "terraform-google-modules/kms/google"
  version    = "~> 1.2"
  depends_on = [module.project] #waits for API config

  project_id      = module.project.project_id
  location        = "us"
  keyring         = "ci-bigquery-keyring"
  keys            = ["foo"]
  prevent_destroy = "false"
}

module "initialize_encryption_account" {
  #pinned to prevent bug with random cache count evaluation, see #82
  source     = "terraform-google-modules/gcloud/google"
  version    = "1.2.0"

  platform              = "linux"
  additional_components = ["bq"]
  #skip_download         = true

  create_cmd_entrypoint = "bq"
  create_cmd_body       = format("show --encryption_service_account --project_id %s", module.project.project_id)
}
