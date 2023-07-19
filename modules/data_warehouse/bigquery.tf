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
    "roles/bigquerydatatransfer.serviceAgent",
  ])

  project = module.project-services.project_id
  role    = each.key
  member  = "serviceAccount:${google_project_service_identity.bigquery_data_transfer_sa.email}"
}

# Create specific service account for DTS Run
# # Set up the DTA service account
resource "google_service_account" "dts" {
  project      = module.project-services.project_id
  account_id   = "cloud-dts-sa-${random_id.id.hex}"
  display_name = "Service Account for Data Transfer Service"
}

# # Grant the DTS Specific service account access
resource "google_project_iam_member" "dts_roles" {
  for_each = toset([
    "roles/bigquery.user",
    "roles/bigquery.dataEditor",
  ])

  project = module.project-services.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.dts.email}"
}

# # Grant the DTS specific service account Token Creator to the DTS Service Identity
resource "google_service_account_iam_binding" "dts_token_creator" {
  service_account_id = google_service_account.dts.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:${google_project_service_identity.bigquery_data_transfer_sa.email}"
  ]

  depends_on = [
    google_project_iam_member.dts_service_account_roles,
  ]
}

# Set up scheduled query
resource "google_bigquery_data_transfer_config" "dts_config" {

  display_name   = "nightlyloadquery"
  project        = module.project-services.project_id
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = "every day 00:00"
  params = {
    query = "CALL `${module.project-services.project_id}.ds_edw.sp_bigqueryml_model`()"
  }
  service_account_name = google_service_account.dts.email

  depends_on = [
    google_project_iam_member.dts_roles,
    google_bigquery_dataset.ds_edw,
    google_service_account_iam_binding.dts_token_creator,
    time_sleep.wait_to_startfile,
  ]
}
