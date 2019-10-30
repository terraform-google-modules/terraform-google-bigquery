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

// HACK -- should use local schema JSON instead of fetching it
//    but right now we're waiting for tables to instantiate
resource "null_resource" "before" {
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
  triggers = {
    "before" = "${null_resource.before.id}"
  }
}

resource "null_resource" "main" {
  depends_on = ["null_resource.delay"]
  count      = length(var.authorized_views)

  triggers = {
    _always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = "python ${path.module}/scripts/bigquery_view_generator.py"

    environment = {
      BQ_PATH          = var.bq_path
      BLACKLIST_FIELDS = var.authorized_views[count.index]["blacklist"]

      TABLE_FQN = replace(var.authorized_views[count.index].table_full_name, "/^([\\w\\-]+)/", var.project_id)
      VIEW_FQN  = replace(var.authorized_views[count.index].view_full_name, "/^([\\w\\-]+)/", var.project_id)
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'WARNING: you MUST delete the view manually in the GCP UI.'"
  }
}
