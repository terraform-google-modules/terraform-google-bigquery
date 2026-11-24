output "connection_id" {
  description = "Fully qualified connection id (project.location.connection_id)."
  value       = local.connection_ref
}

output "connection_service_account" {
  description = "Service account of the created connection."
  value       = local.create_connection ? google_bigquery_connection.connection[0].cloud_resource[0].service_account_id : null
}

output "models" {
  description = "Fully qualified ids of the created models."
  value       = [for id in keys(local.models) : "${var.project_id}.${var.dataset_id}.${id}"]
}
