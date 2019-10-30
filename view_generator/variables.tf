variable "authorized_views" {
  description = "An object defining an authorized view to create, table_full_name: Full table name in the form: project.dataset.table, view_full_name: Full view name in the form: project.dataset.view, blacklist: Comma separated list of fields to exclude in source table from view (defaults to none)."
  default     = []
  type        = list(object({
    table_full_name = string,
    view_full_name  = string,
    blacklist       = string,
  }))
}

variable "project_id" {
  description = "Project where the dataset and table are created"
}

variable "bq_path" {
  description = "Full path to the bq CLI"
  default     = "bq"
}
