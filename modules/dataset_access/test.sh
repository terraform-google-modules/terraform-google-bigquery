#! /usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

DATASET_ID=bq_perms_${RANDOM}

echo "Creating test dataset: ${DATASET_ID}"
bq mk ${DATASET_ID}

echo "Applying terraform"
terraform apply -auto-approve -var-file terraform.tfvars -var "dataset_id=${DATASET_ID}"

echo "Checking permissions"
bq show ${DATASET_ID}

echo "Remove test dataset: ${DATASET_ID}"
bq rm -f ${DATASET_ID}
