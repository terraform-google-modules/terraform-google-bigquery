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

module "bq_find_in_set" {
  source  = "github.com/terraform-google-modules/terraform-google-gcloud"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.find_in_set(str STRING, strList STRING)
  AS (
    CASE
      WHEN STRPOS(str, ',') > 0 THEN 0
      ELSE
      (
        WITH list AS (
          SELECT ROW_NUMBER() OVER() id, l FROM UNNEST(SPLIT(strList, ',')) l
        )
        (SELECT id FROM list WHERE l = str)
      )
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.find_in_set\""
}

module "bq_check_protocol" {
  source  = "github.com/terraform-google-modules/terraform-google-gcloud"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.check_protocol(url STRING)
  AS (
    CASE
      WHEN REGEXP_CONTAINS(url, '^[a-zA-Z]+://') THEN url
      ELSE CONCAT('http://', url)
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.check_protocol\""
}

module "bq_parse_url" {
  source  = "github.com/terraform-google-modules/terraform-google-gcloud"
  enabled = module.bq_check_protocol.wait != "" && var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.parse_url(url STRING, part STRING)
  AS (
    CASE
      -- Return HOST part of the URL.
      WHEN part = 'HOST' THEN SPLIT(\`${var.project_id}\`.${var.dataset_id}.check_protocol(url), '/')[OFFSET(2)]
      WHEN part = 'REF' THEN
        IF(REGEXP_CONTAINS(url, '#'), SPLIT(\`${var.project_id}\`.${var.dataset_id}.check_protocol
        (url), '#')[OFFSET(1)], NULL)
      WHEN part = 'PROTOCOL' THEN RTRIM(REGEXP_EXTRACT(url, '^[a-zA-Z]+://'), '://')
      ELSE ''
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.parse_url\""
}

module "bq_csv_to_struct" {
  source  = "github.com/terraform-google-modules/terraform-google-gcloud"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.csv_to_struct(strList STRING)
  AS (
    CASE
      WHEN REGEXP_CONTAINS(strList, ',') OR REGEXP_CONTAINS(strList, ':') THEN
        (ARRAY(
          WITH list AS (
            SELECT l FROM UNNEST(SPLIT(TRIM(strList), ',')) l WHERE REGEXP_CONTAINS(l, ':')
          )
          SELECT AS STRUCT
              TRIM(SPLIT(l, ':')[OFFSET(0)]) AS key, TRIM(SPLIT(l, ':')[OFFSET(1)]) as value
          FROM list
        ))
      ELSE NULL
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.csv_to_struct\""
}
