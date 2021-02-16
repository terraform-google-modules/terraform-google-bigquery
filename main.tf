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

locals {
  tables          = { for table in var.tables : table["table_id"] => table }
  views           = { for view in var.views : view["view_id"] => view }
  external_tables = { for external_table in var.external_tables : external_table["table_id"] => external_table }

  iam_to_primitive = {
    "roles/bigquery.dataOwner" : "OWNER"
    "roles/bigquery.dataEditor" : "WRITER"
    "roles/bigquery.dataViewer" : "READER"
  }
}

resource "google_bigquery_dataset" "main" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_name
  description                 = var.description
  location                    = var.location
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  project                     = var.project_id
  labels                      = var.dataset_labels

  dynamic "default_encryption_configuration" {
    for_each = var.encryption_key == null ? [] : [var.encryption_key]
    content {
      kms_key_name = var.encryption_key
    }
  }

  dynamic "access" {
    for_each = var.access
    content {
      # BigQuery API converts IAM to primitive roles in its backend.
      # This causes Terraform to show a diff on every plan that uses IAM equivalent roles.
      # Thus, do the conversion between IAM to primitive role here to prevent the diff.
      role = lookup(local.iam_to_primitive, access.value.role, access.value.role)

      domain         = lookup(access.value, "domain", null)
      group_by_email = lookup(access.value, "group_by_email", null)
      user_by_email  = lookup(access.value, "user_by_email", null)
      special_group  = lookup(access.value, "special_group", null)
    }
  }
}

resource "google_bigquery_table" "main" {
  for_each        = local.tables
  dataset_id      = google_bigquery_dataset.main.dataset_id
  friendly_name   = each.key
  table_id        = each.key
  labels          = each.value["labels"]
  schema          = file(each.value["schema"])
  clustering      = each.value["clustering"]
  expiration_time = each.value["expiration_time"]
  project         = var.project_id

  dynamic "time_partitioning" {
    for_each = each.value["time_partitioning"] != null ? [each.value["time_partitioning"]] : []
    content {
      type                     = time_partitioning.value["type"]
      expiration_ms            = time_partitioning.value["expiration_ms"]
      field                    = time_partitioning.value["field"]
      require_partition_filter = time_partitioning.value["require_partition_filter"]
    }
  }
}

resource "google_bigquery_table" "view" {
  for_each      = local.views
  dataset_id    = google_bigquery_dataset.main.dataset_id
  friendly_name = each.key
  table_id      = each.key
  labels        = each.value["labels"]
  project       = var.project_id

  view {
    query          = each.value["query"]
    use_legacy_sql = each.value["use_legacy_sql"]
  }
}

resource "google_bigquery_table" "external_table" {
  for_each        = local.external_tables
  dataset_id      = google_bigquery_dataset.main.dataset_id
  friendly_name   = each.key
  table_id        = each.key
  labels          = each.value["labels"]
  expiration_time = each.value["expiration_time"]
  project         = var.project_id

  external_data_configuration {
    autodetect            = each.value["autodetect"]
    compression           = each.value["compression"]
    ignore_unknown_values = each.value["ignore_unknown_values"]
    max_bad_records       = each.value["max_bad_records"]
    schema                = each.value["schema"]
    source_format         = each.value["source_format"]
    source_uris           = each.value["source_uris"]

    dynamic "csv_options" {
      for_each = each.value["csv_options"] != null ? [each.value["csv_options"]] : []
      content {
        quote                 = csv_options.value["quote"]
        allow_jagged_rows     = csv_options.value["allow_jagged_rows"]
        allow_quoted_newlines = csv_options.value["allow_quoted_newlines"]
        encoding              = csv_options.value["encoding"]
        field_delimiter       = csv_options.value["field_delimiter"]
        skip_leading_rows     = csv_options.value["skip_leading_rows"]
      }
    }

    dynamic "google_sheets_options" {
      for_each = each.value["google_sheets_options"] != null ? [each.value["google_sheets_options"]] : []
      content {
        range             = google_sheets_options.value["range"]
        skip_leading_rows = google_sheets_options.value["skip_leading_rows"]
      }
    }

    dynamic "hive_partitioning_options" {
      for_each = each.value["hive_partitioning_options"] != null ? [each.value["hive_partitioning_options"]] : []
      content {
        mode              = hive_partitioning_options.value["mode"]
        source_uri_prefix = hive_partitioning_options.value["source_uri_prefix"]
      }
    }
  }
}
