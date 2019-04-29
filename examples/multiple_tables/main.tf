/******************************************
   Provider configuration
  *****************************************/
provider "google" {
  version = "~> 2.5.0"
}

module "bigquery" {
  source            = "../.."
  dataset_id        = "foo"
  dataset_name      = "foo"
  description       = "some description"
  expiration        = "${var.expiration}"
  project_id        = "${var.project_id}"
  location          = "US"
  tables            = "${var.tables}"
  time_partitioning = "${var.time_partitioning}"
  dataset_labels    = "${var.dataset_labels }"
  table_labels      = "${var.table_labels}"
}
