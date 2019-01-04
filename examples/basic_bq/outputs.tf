output "dataset_id" {
  value       = "${module.bigquery.dataset_id}"
  description = "update"
}

output "dataset_name" {
  value       = "${module.bigquery.dataset_name}"
  description = "update"
}

output "dataset_project" {
  value       = "${module.bigquery.dataset_project}"
  description = "update"
}

output "dataset_labels" {
  value       = "${module.bigquery.dataset_labels}"
  description = "update"
}

output "table_id" {
  value       = "${module.bigquery.table_id}"
  description = "update"
}

output "table_labels" {
  value       = "${module.bigquery.table_labels}"
  description = "update"
}
