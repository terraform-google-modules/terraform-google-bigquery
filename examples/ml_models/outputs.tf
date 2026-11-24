output "connection_id" {
  value       = module.ml_models.connection_id
  description = "Fully qualified connection id (project.location.connection_id)"
}

output "models" {
  value       = module.ml_models.models
  description = "Fully qualified ids of the created models"
}
