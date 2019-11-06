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
  roles = length(var.roles) > 0 ? jsonencode(var.roles) : var.roles_json
}

resource "null_resource" "assign_permissions" {
  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    command = "touch ~/.bigqueryrc && ${path.module}/build/${var.platform}/bq-perms"

    environment = {
      TARGET_PROJECT_ID = var.project
      TARGET_DATASET_ID = var.dataset_id
      PRESERVE_GROUPS   = var.preserve_special_groups ? "true" : "false"
      ROLES             = local.roles
      VIEWS             = jsonencode(var.views)
      BQ_PATH           = var.bq_path
    }
  }
}

