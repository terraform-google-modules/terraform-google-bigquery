#! /usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

action=$1
dataset_name=$2

function create() {
  drop;

  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${dataset_name}.find_in_set(str STRING, strList STRING)
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

  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${dataset_name}.check_protocol(url STRING)
  AS (
    CASE
      WHEN REGEXP_CONTAINS(url, '^[a-zA-Z]+://') THEN url
      ELSE CONCAT('http://', url)
    END
  );"

  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${dataset_name}.parse_url(url STRING, part STRING)
  AS (
    CASE
      -- Return HOST part of the URL.
      WHEN part = 'HOST' THEN SPLIT(\`${PROJECT_ID}\`.${dataset_name}.check_protocol(url), '/')[OFFSET(2)]
      WHEN part = 'REF' THEN
        IF(REGEXP_CONTAINS(url, '#'), SPLIT(\`${PROJECT_ID}\`.${dataset_name}.check_protocol
        (url), '#')[OFFSET(1)], NULL)
      WHEN part = 'PROTOCOL' THEN RTRIM(REGEXP_EXTRACT(url, '^[a-zA-Z]+://'), '://')
      ELSE ''
    END
  );"

  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${dataset_name}.csv_to_struct(strList STRING)
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
}

function list() {
  ${BQ_PATH} --project_id "${PROJECT_ID}" ls --routines "${dataset_name}"
}

function drop() {
  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "DROP FUNCTION IF EXISTS ${dataset_name}.find_in_set"
  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "DROP FUNCTION IF EXISTS ${dataset_name}.parse_url"
  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "DROP FUNCTION IF EXISTS ${dataset_name}.check_protocol"
  ${BQ_PATH} --project_id "${PROJECT_ID}" query --use_legacy_sql=false "DROP FUNCTION IF EXISTS ${dataset_name}.csv_to_struct"
}

function usage() {
  echo ""
  echo "Shell script for creating and dropping "
  echo ""
  echo ""
  echo "USAGE: ./persistent_udf.sh <action> <dataset_id>"
  echo "All parameters are mandatory"
  echo "action can have the following values: create, drop"
  echo "Example: ./persistent_udf.sh create test_dataset"
}

if [ "${action}" = "create" ]
then
  create;
elif [ "${action}" = "drop" ]
then
  drop;
else
  echo 'Invalid action '"${action}"
  usage;
  exit 1;
fi

