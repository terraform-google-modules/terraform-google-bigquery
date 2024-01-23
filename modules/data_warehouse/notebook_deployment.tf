/*
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

# Define the list of notebook files to be created
locals {
  notebook_names = [
    for s in fileset("${path.root}/templates/notebooks/", "*.tftpl") : trimsuffix(s, ".tftpl")
  ]
}

# Create the notebook files to be uploaded
resource "local_file" "notebooks" {
  count    = length(local.notebook_names)
  filename = "${path.root}/src/function/notebooks/${local.notebook_names[count.index]}.ipynb"
  content = templatefile("${path.root}/templates/notebooks/${local.notebook_names[count.index]}.tftpl", {
    PROJECT_ID = format("\\%s${module.project-services.project_id}\\%s", "\"", "\""),
    REGION     = format("\\%s${var.region}\\%s", "\"", "\""),
    GCS_BUCKET_URI = google_storage_bucket.raw_bucket.url
    }
  )
}

# Create the notebook runtime to save time after deployment
## Grab user email to make them the owner of the runtime
data "google_client_openid_userinfo" "user" {
}

data "google_client_config" "current" {
}

## Create the runtime template
data "http" "create_notebook_template" {
  url    = "https://${var.region}-aiplatform.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/notebookRuntimeTemplates?notebookRuntimeTemplateId=jss_runtime_template"
  method = "POST"
  request_headers = {
    Accept        = "application/json"
    Authorization = "Bearer ${data.google_client_config.current.access_token}"
  }
  request_body = <<EOF
    '{
        "displayName": "jss-notebook-template",
        "description": "jss-notebook",
        "isDefault": true,
        "machineSpec": {
          "machineType": "e2-standard-4"
        },
        "dataPersistentDiskSpec": {
          "diskType": "pd-standard",
          "diskSizeGb": 100,
        },
        "networkSpec": {
          "enableInternetAccess": true
        },
        "idleShutdownConfig": {
          "idleTimeout": 3600,
          "idleShutdownDisabled": false
        }
        "notebookRuntimeType": ONE_CLICK
      }
  EOF
  depends_on = [
  time_sleep.wait_after_apis]
}

resource "time_sleep" "wait_after_template" {
  create_duration = "120s"
  depends_on      = [data.http.create_notebook_template]
}

## API call to create the runtime
data "http" "create_notebook_runtime" {
  url    = "https://${var.region}-aiplatform.googleapis.com/v1/projects/${module.project-services.project_id}/locations/${var.region}/notebookRuntimeTemplates?notebookRuntimeTemplateId=jss_runtime_template"
  method = "POST"
  request_headers = {
    Accept        = "application/json"
    Authorization = "Bearer ${data.google_client_config.current.access_token}"
  }
  request_body = <<EOF
    '{
        "notebookRuntimeTemplate": "jss_runtime_template",
        "notebookRuntime": {
          "runtimeUser": "${data.google_client_openid_userinfo.user.email}"
          "displayName": "jss-notebook-runtime",
          "description": "A runtime to support the notebooks deployed by the Data Warehouse Jump Start Solution",
        }
      }
  EOF
  depends_on = [
    time_sleep.wait_after_template

  ]
}

# Upload the Cloud Function source code to a GCS bucket
## Define/create zip file for the Cloud Function source. This includes notebooks that will be uploaded
data "archive_file" "create_notebook_function_zip" {
  type        = "zip"
  output_path = "${path.root}/tmp/notebooks_function_source.zip"
  source_dir  = "${path.root}/src/function/"

  depends_on = [local_file.notebooks]
}

## Set up a storage bucket for Cloud Function source code
resource "google_storage_bucket" "function_source" {
  name                        = "ds-edw-gcf-source-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  public_access_prevention = "enforced"

  depends_on = [time_sleep.wait_after_apis]

  labels = var.labels
}

## Upload the zip file of the source code to GCS
resource "google_storage_bucket_object" "function_source_upload" {
  name   = "notebooks_function_source.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.create_notebook_function_zip.output_path
}

# Manage Cloud Function permissions and access
## Create a service account to manage the function
resource "google_service_account" "cloud_function_manage_sa" {
  project                      = module.project-services.project_id
  account_id                   = "notebook-deployment"
  display_name                 = "Cloud Functions Service Account"
  description                  = "Service account used to manage Cloud Function"
  create_ignore_already_exists = var.create_ignore_service_accounts

  depends_on = [
    time_sleep.wait_after_apis,
  ]
}

## Define the IAM roles that are granted to the Cloud Function service account
locals {
  cloud_function_roles = [
    "roles/aiplatform.user",         // Needs to predict from endpoints
    "roles/aiplatform.serviceAgent", // Service account role
    "roles/cloudfunctions.admin",    // Service account role to manage access to the remote function
    "roles/dataform.codeEditor",     // Edit access code resources
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/run.invoker",         // Service account role to invoke the remote function
    "roles/storage.objectViewer" // Read GCS files
  ]
}

## Assign required permissions to the function service account
resource "google_project_iam_member" "function_manage_roles" {
  project = module.project-services.project_id
  count   = length(local.cloud_function_roles)
  role    = local.cloud_function_roles[count.index]
  member  = "serviceAccount:${google_service_account.cloud_function_manage_sa.email}"

  depends_on = [google_service_account.cloud_function_manage_sa, google_project_iam_member.dts_roles]
}

## Grant the Cloud Workflows service account access to act as the Cloud Function service account
resource "google_service_account_iam_member" "workflow_auth_function" {
  service_account_id = google_service_account.cloud_function_manage_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.workflow_manage_sa.email}"

  depends_on = [
    google_service_account.workflow_manage_sa,
    google_project_iam_member.function_manage_roles
  ]
}

# Setup Dataform repositories to host notebooks
## Create the Dataform repos
resource "google_dataform_repository" "notebook_repo" {
  count        = length(local.notebook_names)
  provider     = google-beta
  project      = module.project-services.project_id
  region       = var.region
  name         = local.notebook_names[count.index]
  display_name = local.notebook_names[count.index]
  labels = {
    "data-warehouse"         = "true"
    "single-file-asset-type" = "notebook"
  }
  depends_on = [time_sleep.wait_after_apis]
}

## Grant Cloud Function service account access to write to the repo
resource "google_dataform_repository_iam_member" "function_manage_repo" {
  provider   = google-beta
  project    = module.project-services.project_id
  region     = var.region
  role       = "roles/dataform.admin"
  member     = "serviceAccount:${google_service_account.cloud_function_manage_sa.email}"
  count      = length(local.notebook_names)
  repository = local.notebook_names[count.index]
  depends_on = [time_sleep.wait_after_apis, google_service_account_iam_member.workflow_auth_function]
}

## Grant Cloud Workflows service account access to write to the repo
resource "google_dataform_repository_iam_member" "workflow_manage_repo" {
  provider   = google-beta
  project    = module.project-services.project_id
  region     = var.region
  role       = "roles/dataform.admin"
  member     = "serviceAccount:${google_service_account.workflow_manage_sa.email}"
  count      = length(local.notebook_names)
  repository = local.notebook_names[count.index]

  depends_on = [google_service_account_iam_member.workflow_auth_function, google_dataform_repository_iam_member.function_manage_repo]
}

# Create and deploy a Cloud Function to deploy notebooks
## Create the Cloud Function
resource "google_cloudfunctions2_function" "notebook_deploy_function" {
  name        = "deploy-notebooks"
  project     = module.project-services.project_id
  location    = var.region
  description = "A Cloud Function that deploys sample notebooks."
  build_config {
    runtime     = "python310"
    entry_point = "run_it"

    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.function_source_upload.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    # min_instance_count can be set to 1 to improve performance and responsiveness
    min_instance_count               = 0
    available_memory                 = "512Mi"
    timeout_seconds                  = 300
    max_instance_request_concurrency = 1
    available_cpu                    = "2"
    ingress_settings                 = "ALLOW_ALL"
    all_traffic_on_latest_revision   = true
    service_account_email            = google_service_account.cloud_function_manage_sa.email
    environment_variables = {
      "PROJECT_ID" : module.project-services.project_id,
      "REGION" : var.region
    }
  }

  depends_on = [
    time_sleep.wait_after_apis,
    google_project_iam_member.function_manage_roles,
    google_dataform_repository.notebook_repo,
    google_dataform_repository_iam_member.workflow_manage_repo,
    google_dataform_repository_iam_member.function_manage_repo
  ]
}

## Wait for Function deployment to complete
resource "time_sleep" "wait_after_function" {
  create_duration = "5s"
  depends_on      = [google_cloudfunctions2_function.notebook_deploy_function]
}
