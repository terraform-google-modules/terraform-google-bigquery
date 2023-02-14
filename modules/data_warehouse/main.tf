data "google_project" "project" {
  project_id = var.project_id
}

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "13.0.0"
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
    "pubsub.googleapis.com"
  ]
}

#random id
resource "random_id" "id" {
	  byte_length = 4
}

# Set up service account for the Cloud Function to execute as
resource "google_service_account" "cloud_function_service_account" {
  project      = var.project_id
  account_id   = "cloud-function-sa-${random_id.id.hex}"
  display_name = "Service Account for Cloud Function Execution"
}

# TODO: scope this down
resource "google_project_iam_member" "cloud_function_service_account_editor_role" {
  project  = var.project_id
  role     = "roles/editor"
  member   = "serviceAccount:${google_service_account.cloud_function_service_account.email}"

  depends_on = [
    google_service_account.cloud_function_service_account
  ]
}

# TODO: Add scheduled load job

# Set up Storage Buckets
# # Set up the raw storage bucket
resource "google_storage_bucket" "raw_bucket" {
  name          = "ds-edw-raw-${random_id.id.hex}"
  project     = var.project_id
  location      = var.region
  uniform_bucket_level_access = true
  force_destroy = true

  # public_access_prevention = "enforced" # need to validate if this is a hard requirement
}

# # Set up the provisioning bucketstorage bucket
resource "google_storage_bucket" "provisioning_bucket" {
  name          = "ds-edw-provisioner-${random_id.id.hex}"
  project     = var.project_id
  location      = var.region
  uniform_bucket_level_access = true
  force_destroy = true

  # public_access_prevention = "enforced"
}

# Set up BigQuery resources
# # Create the BigQuery dataset
resource "google_bigquery_dataset" "ds_edw" {
  project     = var.project_id
  dataset_id    = "ds_edw"
  friendly_name = "My EDW Dataset"
  description   = "My EDW Dataset with tables"
  location      = var.region
}

# # Create a BigQuery connection
resource "google_bigquery_connection" "ds_connection" {
   project     = var.project_id
   connection_id = "ds_connection"
   location      = var.region
   friendly_name = "Storage Bucket Connection"
   cloud_resource {}
}

# # Grant IAM access to the BigQuery Connection account for Cloud Storage
resource "google_project_iam_member" "bq_connection_iam_object_viewer" {
  project  = var.project_id
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${google_bigquery_connection.ds_connection.cloud_resource[0].service_account_id}"

  depends_on = [
    google_bigquery_connection.ds_connection
  ]
}

# # Upload files
resource "google_storage_bucket_object" "parquet_files" {
  for_each = fileset("assets/parquet/", "*")

  bucket = google_storage_bucket.raw_bucket.name
  name   = each.value
  source = "assets/parquet/${each.value}"

}

# # Create a BigQuery external table
resource "google_bigquery_table" "tbl_edw_taxi" {
  dataset_id = google_bigquery_dataset.ds_edw.dataset_id
  table_id   = "taxi_trips"
  project    = var.project_id
  deletion_protection = false 

  external_data_configuration {
    autodetect    = true
    connection_id =  "${var.project_id}.${var.region}.ds_connection"
    source_format = "PARQUET"
    source_uris = ["gs://${google_storage_bucket.raw_bucket.name}/taxi-*.Parquet"]
    
  }

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
    google_storage_bucket_object.parquet_files
  ]
}

# Load Queries for Stored Procedure Execution
# # Load Lookup Data Tables
data "template_file" "sp_provision_lookup_tables" {
  template = "${file("assets/sql/sp_provision_lookup_tables.sql")}"
  vars = {
    project_id = var.project_id
  }  
}
resource "google_bigquery_routine" "sp_provision_lookup_tables" {
  project     = var.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_provision_lookup_tables"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.sp_provision_lookup_tables.rendered}"

  depends_on = [
    google_bigquery_dataset.ds_edw,
    data.template_file.sp_provision_lookup_tables
  ]
}


# # Add Looker Studio Data Report Procedure
data "template_file" "sp_lookerstudio_report" {
  template = "${file("assets/sql/sp_lookerstudio_report.sql")}"
  vars = {
    project_id = var.project_id
  }  
}
resource "google_bigquery_routine" "sproc_sp_demo_datastudio_report" {
  project     = var.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_lookerstudio_report"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.sp_lookerstudio_report.rendered}"

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_lookerstudio_report
  ]
}

# # Add Sample Queries
data "template_file" "sp_sample_queries" {
  template = "${file("assets/sql/sp_sample_queries.sql")}"
  vars = {
    project_id = var.project_id
  }  
}
resource "google_bigquery_routine" "sp_sample_queries" {
  project     = var.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_sample_queries"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.sp_sample_queries.rendered}"

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_sample_queries
  ]
}


# # Add Bigquery ML Model
data "template_file" "sp_bigqueryml_model" {
  template = "${file("assets/sql/sp_bigqueryml_model.sql")}"
  vars = {
    project_id = var.project_id
  }  
}
resource "google_bigquery_routine" "sp_bigqueryml_model" {
  project     = var.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_bigqueryml_model"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.sp_bigqueryml_model.rendered}"

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_bigqueryml_model
  ]
}

# # Add Translation Scripts
data "template_file" "sp_sample_translation_queries" {
  template = "${file("assets/sql/sp_sample_translation_queries.sql")}"
  vars = {
    project_id = var.project_id
  }  
}
resource "google_bigquery_routine" "sp_sample_translation_queries" {
  project     = var.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_sample_translation_queries"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = "${data.template_file.sp_sample_translation_queries.rendered}"

  depends_on = [
    google_bigquery_table.tbl_edw_taxi,
    data.template_file.sp_sample_translation_queries
  ]
}

# Add Scheduled Query
# # Set up DTS permissions
resource "google_project_iam_member" "dts_permissions_token" {
  project = data.google_project.project.project_id
  role   = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-bigquerydatatransfer.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "dts_permissions_agent" {
  project = data.google_project.project.project_id
  role   = "roles/bigquerydatatransfer.serviceAgent"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-bigquerydatatransfer.iam.gserviceaccount.com"
}

# Set up scheduled query
resource "google_bigquery_data_transfer_config" "dts_config" {
  
  display_name           = "nightlyloadquery"
  project                = var.project_id
  location               = var.region
  data_source_id         = "scheduled_query"
  schedule               = "every day 00:00"
  params = {
    query                           = "CALL `${var.project_id}.ds_edw.sp_lookerstudio_report`()"
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
  source_dir  = "assets/bigquery-external-function" 
  output_path = "assets/bigquery-external-function.zip"

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

# # Create the function
resource "google_cloudfunctions2_function" "function" {
  #provider = google-beta
  project     = var.project_id
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
        PROJECT_ID = var.project_id
        BUCKET_ID = google_storage_bucket.raw_bucket.name
    }
    service_account_email = google_service_account.cloud_function_service_account.email
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.storage.object.v1.finalized"
    event_filters {
         attribute = "bucket"
         value = google_storage_bucket.raw_bucket.name
    }
    retry_policy   = "RETRY_POLICY_RETRY"
    }

  depends_on = [
    google_storage_bucket.provisioning_bucket,
    google_storage_bucket.raw_bucket,
    google_project_iam_member.cloud_function_service_account_editor_role
  ]
} 



resource "google_storage_bucket_object" "startfile" {
  bucket = google_storage_bucket.raw_bucket.name
  name   = "startfile"
  source = "assets/startfile"

  depends_on = [
    google_cloudfunctions2_function.function
  ]

}