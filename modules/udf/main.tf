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

resource "null_resource" "main" {
  count = var.add_udfs ? 1 : 0

  triggers = {
    _always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = "${path.module}/scripts/persistent_udfs.sh create ${var.dataset_id}"

    environment = {
      DATASET_ID = var.dataset_id
      BQ_PATH    = var.bq_path
      PROJECT_ID = var.project_id
    }
  }
}

