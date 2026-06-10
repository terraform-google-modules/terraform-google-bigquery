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
## Create the BigQuery dataset
resource "google_bigquery_dataset" "ds_edw" {
  project                    = module.project-services.project_id
  dataset_id                 = "thelook"
  friendly_name              = "My EDW Dataset"
  description                = "My EDW Dataset with tables"
  location                   = var.region
  labels                     = var.labels
  delete_contents_on_destroy = var.force_destroy

  depends_on = [time_sleep.wait_after_apis]
}

## Create a BigQuery connection for Cloud Storage to create BigLake tables
resource "google_bigquery_connection" "ds_connection" {
  project       = module.project-services.project_id
  connection_id = "ds_connection"
  location      = var.region
  friendly_name = "Storage Bucket Connection"
  cloud_resource {}
  depends_on = [time_sleep.wait_after_apis]
}

## Grant IAM access to the BigQuery Connection account for Cloud Storage
resource "google_project_iam_member" "bq_connection_iam_object_viewer" {
  project = module.project-services.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_bigquery_connection.ds_connection.cloud_resource[0].service_account_id}"

  depends_on = [google_bigquery_connection.ds_connection]
}

## Create a BigQuery connection for Vertex AI to support GenerativeAI use cases
resource "google_bigquery_connection" "vertex_ai_connection" {
  project       = module.project-services.project_id
  connection_id = "genai_connection"
  location      = var.region
  friendly_name = "BigQuery ML Connection"
  cloud_resource {}
  depends_on = [time_sleep.wait_after_apis]
}

## Define IAM roles granted to the BigQuery Connection service account
locals {
  bq_vertex_ai_roles = [
    "roles/aiplatform.user",
    "roles/bigquery.connectionUser",
    "roles/serviceusage.serviceUsageConsumer",
  ]
}

## Grant IAM access to the BigQuery Connection account for Vertex AI
resource "google_project_iam_member" "bq_connection_iam_vertex_ai" {
  count   = length(local.bq_vertex_ai_roles)
  role    = local.bq_vertex_ai_roles[count.index]
  project = module.project-services.project_id
  member  = "serviceAccount:${google_bigquery_connection.vertex_ai_connection.cloud_resource[0].service_account_id}"

  depends_on = [google_bigquery_connection.vertex_ai_connection, google_project_iam_member.bq_connection_iam_object_viewer]
}

# Create data tables in BigQuery
## Create a Biglake table for events with metadata caching
resource "google_bigquery_table" "tbl_edw_events" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "events"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/events_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/events.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for inventory_items
resource "google_bigquery_table" "tbl_edw_inventory_items" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "inventory_items"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/inventory_items_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/inventory_items.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table with metadata caching for order_items
resource "google_bigquery_table" "tbl_edw_order_items" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "order_items"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/order_items_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/order_items.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for orders
resource "google_bigquery_table" "tbl_edw_orders" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "orders"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/orders_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/orders.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for products
resource "google_bigquery_table" "tbl_edw_products" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "products"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/products_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/products.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for products
resource "google_bigquery_table" "tbl_edw_users" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "users"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/users_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/users.parquet"]
  }

  labels = var.labels
}

# Load Queries and Execute Jobs directly timed with dependencies

## Execute Query to load Distribution Center Lookup Data Table
resource "google_bigquery_job" "run_sp_provision_lookup_tables" {
  job_id   = "run_sp_provision_lookup_tables_${random_id.id.hex}"
  project  = module.project-services.project_id
  location = var.region

  query {
    query = templatefile("${path.module}/src/sql/sp_provision_lookup_tables.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
  }

  depends_on = [
    google_bigquery_dataset.ds_edw
  ]
}

# Wait for BigQuery storage layers to fully propagate the newly provisioned lookup tables
resource "time_sleep" "wait_after_lookup_tables" {
  create_duration = "30s"
  depends_on      = [google_bigquery_job.run_sp_provision_lookup_tables]
}

## Add Looker Studio Data Report Views
resource "google_bigquery_table" "view_lookerstudio_report_distribution_centers" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "lookerstudio_report_distribution_centers"
  project             = module.project-services.project_id
  deletion_protection = false

  view {
    query = templatefile("${path.module}/src/sql/view_lookerstudio_report_distribution_centers.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
    use_legacy_sql = false
  }

  labels = var.labels

  depends_on = [
    google_bigquery_table.tbl_edw_order_items,
    google_bigquery_table.tbl_edw_inventory_items,
    time_sleep.wait_after_lookup_tables,
    time_sleep.wait_after_data_transfer
  ]
}

resource "google_bigquery_table" "view_lookerstudio_report_profit" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "lookerstudio_report_profit"
  project             = module.project-services.project_id
  deletion_protection = false

  view {
    query = templatefile("${path.module}/src/sql/view_lookerstudio_report_profit.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
    use_legacy_sql = false
  }

  labels = var.labels

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
    time_sleep.wait_after_data_transfer
  ]
}

## Execute Sample Analytical Queries Job
resource "google_bigquery_job" "run_sp_sample_queries" {
  job_id   = "run_sp_sample_queries_${random_id.id.hex}"
  project  = module.project-services.project_id
  location = var.region

  query {
    query = templatefile("${path.module}/src/sql/sp_sample_queries.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
  }

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
    google_bigquery_table.tbl_edw_order_items,
    time_sleep.wait_after_data_transfer
  ]
}

## Execute BigQuery ML Model Clustering Job
resource "google_bigquery_job" "run_sp_bigqueryml_model" {
  job_id   = "run_sp_bigqueryml_model_${random_id.id.hex}"
  project  = module.project-services.project_id
  location = var.region

  query {
    query = templatefile("${path.module}/src/sql/sp_bigqueryml_model.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
  }

  depends_on = [
    google_bigquery_table.tbl_edw_order_items,
    time_sleep.wait_after_data_transfer
  ]
}

## Execute BigQuery ML LLM Text Generation Remote Model Creation Job
resource "google_bigquery_job" "run_sp_bigqueryml_generate_create" {
  job_id   = "run_sp_bigqueryml_generate_create_${random_id.id.hex}"
  project  = module.project-services.project_id
  location = var.region

  query {
    query = templatefile("${path.module}/src/sql/sp_bigqueryml_generate_create.sql", {
      project_id    = module.project-services.project_id,
      dataset_id    = google_bigquery_dataset.ds_edw.dataset_id,
      connection_id = google_bigquery_connection.vertex_ai_connection.id,
      model_name    = var.text_generation_model_name,
      region        = var.region
    })
  }

  depends_on = [
    google_bigquery_job.run_sp_bigqueryml_model,
    google_project_iam_member.bq_connection_iam_vertex_ai
  ]
}

## Execute BigQuery ML LLM Cluster Description Query Job
resource "google_bigquery_job" "run_sp_bigqueryml_generate_describe" {
  job_id   = "run_sp_bigqueryml_generate_describe_${random_id.id.hex}"
  project  = module.project-services.project_id
  location = var.region

  query {
    query = templatefile("${path.module}/src/sql/sp_bigqueryml_generate_describe.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id,
      model_name = var.text_generation_model_name
    })
  }

  depends_on = [
    google_bigquery_job.run_sp_bigqueryml_generate_create
  ]
}

## Execute Sample Translation Queries Job
resource "google_bigquery_job" "run_sp_sample_translation_queries" {
  job_id   = "run_sp_sample_translation_queries_${random_id.id.hex}"
  project  = module.project-services.project_id
  location = var.region

  query {
    query = templatefile("${path.module}/src/sql/sp_sample_translation_queries.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
  }

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
    time_sleep.wait_after_data_transfer
  ]
}

# Add Scheduled Query

# Create specific service account for DTS Run
## Create a DTS specific service account
resource "google_service_account" "dts" {
  project                      = module.project-services.project_id
  account_id                   = "cloud-dts-sa-${random_id.id.hex}"
  display_name                 = "Service Account for Data Transfer Service"
  description                  = "Service account used to manage Data Transfer Service"
  create_ignore_already_exists = var.create_ignore_service_accounts

  depends_on = [time_sleep.wait_after_apis]

}

## Define the IAM roles granted to the DTS service account
locals {
  dts_roles = [
    "roles/bigquery.user",
    "roles/bigquery.dataEditor",
    "roles/bigquery.connectionUser",
    "roles/iam.serviceAccountTokenCreator"
  ]
}

## Grant the DTS Specific service account access
resource "google_project_iam_member" "dts_roles" {
  project = module.project-services.project_id
  count   = length(local.dts_roles)
  role    = local.dts_roles[count.index]
  member  = "serviceAccount:${google_service_account.dts.email}"

  depends_on = [time_sleep.wait_after_apis, google_project_iam_member.bq_connection_iam_vertex_ai]
}

# Set up scheduled query
resource "google_bigquery_data_transfer_config" "dts_config" {

  display_name   = "nightlyloadquery"
  project        = module.project-services.project_id
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = "every day 00:00"
  params = {
    query = templatefile("${path.module}/src/sql/sp_bigqueryml_model.sql", {
      project_id = module.project-services.project_id,
      dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    })
  }
  service_account_name = google_service_account.dts.email

  depends_on = [
    google_project_iam_member.dts_roles,
    google_bigquery_dataset.ds_edw
  ]
}
