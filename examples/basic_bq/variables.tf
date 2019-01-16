variable "dataset_id" {}
variable "dataset_name" {}
variable "description" {}
variable "expiration" {}
variable "project_id" {}
variable "table_id" {}
variable "region" {}
variable "time_partitioning" {}
variable "schema_file" {}

variable "dataset_labels" {
  type = "map"
}

variable "table_labels" {
  type = "map"
}
