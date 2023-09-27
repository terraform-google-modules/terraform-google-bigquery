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

  depends_on = [time_sleep.wait_after_apis]
}

# # Create a BigQuery connection
resource "google_bigquery_connection" "ds_connection" {
  project       = module.project-services.project_id
  connection_id = "ds_connection"
  location      = var.region
  friendly_name = "Storage Bucket Connection"
  cloud_resource {}
  depends_on = [time_sleep.wait_after_apis]
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

# # Create a Biglake table for events with metadata caching
resource "google_bigquery_table" "tbl_edw_events" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "events"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection
  # max_staleness =  "1:0:0"

  schema = file("${path.module}/src/schema/events_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/events.parquet"]
    # metadata_cache_mode = "AUTOMATIC"
  }

  labels = var.labels

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
  ]
}

# # Create a Biglake table for inventory_items
resource "google_bigquery_table" "tbl_edw_inventory_items" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "inventory_items"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection
  # max_staleness =  "1:0:0"

  schema = file("${path.module}/src/schema/inventory_items_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/inventory_items.parquet"]
    # metadata_cache_mode = "AUTOMATIC"
  }

  labels = var.labels

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
  ]
}

# # Create a Biglake table with metadata caching for order_items
resource "google_bigquery_table" "tbl_edw_order_items" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "order_items"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection
  # max_staleness =  "1:0:0"

  schema = file("${path.module}/src/schema/order_items_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/order_items.parquet"]
    # metadata_cache_mode = "AUTOMATIC"
  }

  labels = var.labels

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
  ]
}

# # Create a Biglake table for orders
resource "google_bigquery_table" "tbl_edw_orders" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "orders"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection
  # max_staleness =  "1:0:0"

  schema = file("${path.module}/src/schema/orders_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/orders.parquet"]
    # metadata_cache_mode = "AUTOMATIC"
  }

  labels = var.labels

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
  ]
}

# # Create a Biglake table for products
resource "google_bigquery_table" "tbl_edw_products" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "products"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection
  # max_staleness =  "1:0:0"

  schema = file("${path.module}/src/schema/products_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/products.parquet"]
    # metadata_cache_mode = "AUTOMATIC"
  }

  labels = var.labels

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
  ]
}

# # Create a Biglake table for products
resource "google_bigquery_table" "tbl_edw_users" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "users"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection
  # max_staleness =  "1:0:0"

  schema = file("${path.module}/src/schema/users_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/users.parquet"]
    # metadata_cache_mode = "AUTOMATIC"
  }

  labels = var.labels

  depends_on = [
    google_bigquery_connection.ds_connection,
    google_storage_bucket.raw_bucket,
  ]
}

# Load Queries for Stored Procedure Execution
# # Load Distribution Center Lookup Data Tables
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

# Add Looker Studio Data Report Procedure
resource "google_bigquery_routine" "sproc_sp_demo_lookerstudio_report" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_lookerstudio_report"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_lookerstudio_report.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
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
    google_bigquery_table.tbl_edw_inventory_items,
  ]
}


# Add Bigquery ML Model
resource "google_bigquery_routine" "sp_bigqueryml_model" {
  project         = module.project-services.project_id
  dataset_id      = google_bigquery_dataset.ds_edw.dataset_id
  routine_id      = "sp_bigqueryml_model"
  routine_type    = "PROCEDURE"
  language        = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_bigqueryml_model.sql", { project_id = module.project-services.project_id })

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
  ]
}

# Add Scheduled Query
# # Set up DTS permissions
resource "google_project_service_identity" "bigquery_data_transfer_sa" {
  provider = google-beta
  project  = module.project-services.project_id
  service  = "bigquerydatatransfer.googleapis.com"

  depends_on = [time_sleep.wait_after_apis]
}

# # Grant the DTS service account access
resource "google_project_iam_member" "dts_service_account_roles" {
  for_each = toset([
    "roles/bigquerydatatransfer.serviceAgent",
  ])

  project = module.project-services.project_id
  role    = each.key
  member  = "serviceAccount:${google_project_service_identity.bigquery_data_transfer_sa.email}"

  depends_on = [time_sleep.wait_after_apis]
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

  depends_on = [google_service_account.dts]
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
    google_service_account.dts,
    google_project_service_identity.bigquery_data_transfer_sa
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
