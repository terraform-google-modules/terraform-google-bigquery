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
  version                     = "14.2"
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
    "pubsub.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "config.googleapis.com",
    "workflows.googleapis.com",
    "serviceusage.googleapis.com",
  ]

}

#random id
resource "random_id" "id" {
  byte_length = 4
}

# Set up Storage Buckets

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
resource "google_storage_bucket_iam_binding" "bq_connection_iam_object_viewer" {
  bucket = google_storage_bucket.raw_bucket.name
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_bigquery_connection.ds_connection.cloud_resource[0].service_account_id}",
  ]

  depends_on = [
    google_bigquery_connection.ds_connection,
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
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/new-york-taxi-trips/tlc-yellow-trips-2022/taxi-*.Parquet"]

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
    google_storage_bucket.raw_bucket,
  ]
}

# Load Queries for Stored Procedure Execution
# # Load Lookup Data Tables
resource "google_bigquery_routine" "sp_provision_lookup_tables" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_provision_lookup_tables"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_provision_lookup_tables.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_dataset.ds_edw,
  ]
}


# # Add Looker Studio Data Report Procedure
resource "google_bigquery_routine" "sproc_sp_demo_datastudio_report" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_lookerstudio_report"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_lookerstudio_report.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
  ]
}

# # Add Sample Queries
resource "google_bigquery_routine" "sp_sample_queries" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_sample_queries"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_sample_queries.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
  ]
}

# # Add Bigquery ML Model
resource "google_bigquery_routine" "sp_bigqueryml_model" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_bigqueryml_model"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_bigqueryml_model.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
  ]
}

# # Add Translation Scripts
resource "google_bigquery_routine" "sp_sample_translation_queries" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_sample_translation_queries"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_sample_translation_queries.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
  ]
}

# Add Scheduled Query
# # Set up DTS permissions
resource "google_project_service_identity" "bigquery_data_transfer_sa" {
  provider = google-beta
  project  = module.project-services.project_id
  service  = "bigquerydatatransfer.googleapis.com"
}

# # Grant the DTS service account access
resource "google_project_iam_member" "dts_service_account_roles" {
  for_each = toset([
    "roles/iam.serviceAccountTokenCreator",
    "roles/bigquerydatatransfer.serviceAgent",
    "roles/bigquery.user",
    "roles/bigquery.dataEditor",
  ])

  project = module.project-services.project_id
  role    = each.key
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
    google_project_iam_member.dts_service_account_roles,
    google_bigquery_dataset.ds_edw,
  ]
}

# # Sleep for 60 seconds to drop start file
resource "time_sleep" "wait_30_seconds_to_startfile" {
  depends_on = [
    google_storage_notification.notification,
    google_eventarc_trigger.trigger_pubsub_tf,
  ]

  create_duration = "30s"
}

resource "google_storage_bucket_object" "startfile" {
  bucket = google_storage_bucket.provisioning_bucket.name
  name   = "startfile"
  source = "${path.module}/src/startfile"

  depends_on = [
    time_sleep.wait_30_seconds_to_startfile
  ]

}

# Create Eventarc Trigger
// Create a Pub/Sub topic.
resource "google_pubsub_topic" "topic" {
  name    = "provisioning-topic"
  project = module.project-services.project_id
}

resource "google_pubsub_topic_iam_binding" "binding" {
  project = module.project-services.project_id
  topic   = google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

# # Get the GCS service account to trigger the pub/sub notification
data "google_storage_project_service_account" "gcs_account" {
  project = module.project-services.project_id
}

# # Create the Storage trigger
resource "google_storage_notification" "notification" {
  provider       = google
  bucket         = google_storage_bucket.provisioning_bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  depends_on     = [google_pubsub_topic_iam_binding.binding]
}

# # Create the Eventarc trigger
resource "google_eventarc_trigger" "trigger_pubsub_tf" {
  project  = module.project-services.project_id
  name     = "trigger-pubsub-tf"
  location = var.region
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"


  }
  destination {
    workflow = google_workflows_workflow.workflow.id
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.topic.id
    }
  }
  service_account = google_service_account.eventarc_service_account.email

  depends_on = [
    google_workflows_workflow.workflow,
    google_project_iam_member.eventarc_service_account_invoke_role,
  ]
}

# Set up Eventarc service account for the Trigger to execute as
# # Set up the Eventarc service account
resource "google_service_account" "eventarc_service_account" {
  project      = module.project-services.project_id
  account_id   = "eventarc-sa-${random_id.id.hex}"
  display_name = "Service Account for Cloud Eventarc"
}

# # Grant the Eventarc service account Workflow Invoker Access
resource "google_project_iam_member" "eventarc_service_account_invoke_role" {
  project = module.project-services.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.eventarc_service_account.email}"

  depends_on = [
    google_service_account.eventarc_service_account
  ]
}

# # Get the Pub/Sub service account to trigger the pub/sub notification
# # TODO: File bug for this to be a pickable service account
resource "google_project_iam_member" "pub_sub_permissions_token" {
  project = module.project-services.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
