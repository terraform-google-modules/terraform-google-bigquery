module "bigquery" {
  source            = "../../.."
  dataset_id        = "${var.dataset_id}"
  dataset_name      = "${var.dataset_name}"
  description       = "${var.description}"
  expiration        = "${var.expiration}"
  project_id        = "${var.project_id}"
  table_id          = "${var.table_id}"
  time_partitioning = "${var.time_partitioning}"
  schema_file       = "${var.schema_file}"
}
