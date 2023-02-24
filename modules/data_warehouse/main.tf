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

data "google_project" "project" {
  project_id = var.project_id
}

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "14.1"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "compute.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "datacatalog.googleapis.com",
    "datalineage.googleapis.com",
    "eventarc.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigquerystorage.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
    "run.googleapis.com",
    "pubsub.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "cloudfunctions.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "artifactregistry.googleapis.com",
    "config.googleapis.com",
  ]
}

#random id
resource "random_id" "id" {
  byte_length = 4
}

# Set up service account for the Cloud Function to execute as
resource "google_service_account" "cloud_function_service_account" {
  project      = module.project-services.project_id
  account_id   = "cloud-function-sa-${random_id.id.hex}"
  display_name = "Service Account for Cloud Function Execution"
}

# TODO: scope this down
resource "google_project_iam_member" "cloud_function_service_account_editor_role" {
  project = module.project-services.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.cloud_function_service_account.email}"

  depends_on = [
    google_service_account.cloud_function_service_account
  ]
}

# Set up Storage Buckets
# # Set up the export storage bucket
resource "google_storage_bucket" "export_bucket" {
  name                        = "ds-edw-export-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = "us-central1"
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  # public_access_prevention = "enforced" # need to validate if this is a hard requirement
}

# # Set up the raw storage bucket
resource "google_storage_bucket" "raw_bucket" {
  name                        = "ds-edw-raw-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  # public_access_prevention = "enforced" # need to validate if this is a hard requirement
}

# # Set up the provisioning bucketstorage bucket
resource "google_storage_bucket" "provisioning_bucket" {
  name                        = "ds-edw-provisioner-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  # public_access_prevention = "enforced"
}

# Set up BigQuery resources
# # Create the BigQuery dataset
resource "google_bigquery_dataset" "ds_edw" {
  project                    = module.project-services.project_id
  dataset_id                 = "ds_edw"
  friendly_name              = "My EDW Dataset"
  description                = "My EDW Dataset with tables"
  location                   = var.region
  labels                     = var.labels
  delete_contents_on_destroy = var.force_destroy
}

# # Create a BigQuery connection
resource "google_bigquery_connection" "ds_connection" {
  project       = module.project-services.project_id
  connection_id = "ds_connection"
  location      = var.region
  friendly_name = "Storage Bucket Connection"
  cloud_resource {}
}

# # Grant IAM access to the BigQuery Connection account for Cloud Storage
resource "google_project_iam_member" "bq_connection_iam_object_viewer" {
  project = module.project-services.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_bigquery_connection.ds_connection.cloud_resource[0].service_account_id}"

  depends_on = [
    google_bigquery_connection.ds_connection
  ]
}

# # Create a BigQuery external table
resource "google_bigquery_table" "tbl_edw_taxi" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "taxi_trips"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  external_data_configuration {
    autodetect    = true
    connection_id = "${module.project-services.project_id}.${var.region}.ds_connection"
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/taxi-*.Parquet"]

  }

  schema = <<EOF
[
  {
    "name": "vendor_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "pickup_datetime",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "dropoff_datetime",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "passenger_count",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "trip_distance",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "rate_code",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "store_and_fwd_flag",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "payment_type",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "fare_amount",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "extra",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "mta_tax",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "tip_amount",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "tolls_amount",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "imp_surcharge",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "airport_fee",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "total_amount",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "pickup_location_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "data_file_year",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "data_file_month",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": ""
  }
]
EOF

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket
  ]
}

# Load Queries for Stored Procedure Execution
# # Load Lookup Data Tables
data "template_file" "sp_provision_lookup_tables" {
  template = file("${path.module}/assets/sql/sp_provision_lookup_tables.sql")
  vars = {
    project_id = module.project-services.project_id
  }
}
resource "google_bigquery_routine" "sp_provision_lookup_tables" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_provision_lookup_tables"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = data.template_file.sp_provision_lookup_tables.rendered

  depends_on = [
    google_bigquery_dataset.ds_edw,
    data.template_file.sp_provision_lookup_tables
  ]
}


# # Add Looker Studio Data Report Procedure
data "template_file" "sp_lookerstudio_report" {
  template = file("${path.module}/assets/sql/sp_lookerstudio_report.sql")
  vars = {
    project_id = module.project-services.project_id
  }
}
resource "google_bigquery_routine" "sproc_sp_demo_datastudio_report" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_lookerstudio_report"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = data.template_file.sp_lookerstudio_report.rendered

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_lookerstudio_report
  ]
}

# # Add Sample Queries
data "template_file" "sp_sample_queries" {
  template = file("${path.module}/assets/sql/sp_sample_queries.sql")
  vars = {
    project_id = module.project-services.project_id
  }
}
resource "google_bigquery_routine" "sp_sample_queries" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_sample_queries"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = data.template_file.sp_sample_queries.rendered

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_sample_queries
  ]
}

# # Add Bigquery ML Model
data "template_file" "sp_bigqueryml_model" {
  template = file("${path.module}/assets/sql/sp_bigqueryml_model.sql")
  vars = {
    project_id = module.project-services.project_id
  }
}
resource "google_bigquery_routine" "sp_bigqueryml_model" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_bigqueryml_model"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = data.template_file.sp_bigqueryml_model.rendered

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_bigqueryml_model
  ]
}

# # Add Translation Scripts
data "template_file" "sp_sample_translation_queries" {
  template = file("${path.module}/assets/sql/sp_sample_translation_queries.sql")
  vars = {
    project_id = module.project-services.project_id
  }
}
resource "google_bigquery_routine" "sp_sample_translation_queries" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_sample_translation_queries"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = data.template_file.sp_sample_translation_queries.rendered

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_sample_translation_queries
  ]
}

# Add Scheduled Query
# # Set up DTS permissions
resource "google_project_service_identity" "bigquery_data_transfer_sa" {
  provider = google-beta
  project  = module.project-services.project_id
  service  = "bigquerydatatransfer.googleapis.com"
}

resource "google_project_iam_member" "dts_permissions_token" {
  project = data.google_project.project.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_project_service_identity.bigquery_data_transfer_sa.email}"
}

resource "google_project_iam_member" "dts_permissions_agent" {
  project = data.google_project.project.project_id
  role    = "roles/bigquerydatatransfer.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.bigquery_data_transfer_sa.email}"
}

# Set up scheduled query
resource "google_bigquery_data_transfer_config" "dts_config" {

  display_name   = "nightlyloadquery"
  project        = module.project-services.project_id
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = "every day 00:00"
  params = {
    query = "CALL `${module.project-services.project_id}.ds_edw.sp_lookerstudio_report`()"
  }

  depends_on = [
    google_project_iam_member.dts_permissions_token,
    google_project_iam_member.dts_permissions_agent,
    google_bigquery_dataset.ds_edw
  ]
}

# Create a Cloud Function resource
# # Zip the function file
data "archive_file" "bigquery_external_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/assets/bigquery-external-function"
  output_path = "${path.module}/assets/bigquery-external-function.zip"

  depends_on = [
    google_storage_bucket.provisioning_bucket
  ]
}

# # Place the function file on Cloud Storage
resource "google_storage_bucket_object" "cloud_function_zip_upload" {
  name   = "assets/bigquery-external-function.zip"
  bucket = google_storage_bucket.provisioning_bucket.name
  source = data.archive_file.bigquery_external_function_zip.output_path

  depends_on = [
    google_storage_bucket.provisioning_bucket,
    data.archive_file.bigquery_external_function_zip
  ]
}

data "google_storage_project_service_account" "gcs_account" {
  project = module.project-services.project_id
}

// GCS CloudEvent triggers, the GCS service account requires the Pub/Sub Publisher
resource "google_project_iam_member" "pubsub" {
  project = module.project-services.project_id

  role   = "roles/pubsub.publisher"
  member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

# # Sleep for a few minutes to let Eventarc sync up
resource "time_sleep" "wait_for_eventarc" {
  create_duration = "180s"
  depends_on = [
    google_storage_bucket.provisioning_bucket,
    google_storage_bucket.raw_bucket,
    google_project_iam_member.cloud_function_service_account_editor_role,
    google_project_iam_member.pubsub,
  ]
}


# # Create the function
resource "google_cloudfunctions2_function" "function" {
  #provider = google-beta
  project     = module.project-services.project_id
  name        = "bq-sp-transform-${random_id.id.hex}"
  location    = var.region
  description = "gcs-load-bq"

  build_config {
    runtime     = "python310"
    entry_point = "bq_sp_transform"
    source {
      storage_source {
        bucket = google_storage_bucket.provisioning_bucket.name
        object = "assets/bigquery-external-function.zip"
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 540
    environment_variables = {
      PROJECT_ID       = module.project-services.project_id
      BUCKET_ID        = google_storage_bucket.raw_bucket.name
      EXPORT_BUCKET_ID = google_storage_bucket.export_bucket.name
    }
    service_account_email = google_service_account.cloud_function_service_account.email
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.storage.object.v1.finalized"
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.provisioning_bucket.name
    }
    retry_policy = "RETRY_POLICY_RETRY"
  }

  depends_on = [
    time_sleep.wait_for_eventarc
  ]
}

resource "google_project_iam_member" "workflow_event_receiver" {
  project = module.project-services.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_storage_bucket_object" "startfile" {
  bucket = google_storage_bucket.provisioning_bucket.name
  name   = "startfile"
  source = "${path.module}/assets/startfile"

  depends_on = [
    google_cloudfunctions2_function.function
  ]

}
