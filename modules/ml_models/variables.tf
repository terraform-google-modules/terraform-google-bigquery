variable "project_id" {
  type        = string
  description = "The project where the connection and models are created."
}

variable "dataset_id" {
  type        = string
  description = "The (existing) dataset the models are created in."
}

variable "location" {
  type        = string
  default     = "EU"
  description = "Location of the connection and the model jobs. Must match the dataset location."
}

variable "connection" {
  type = object({
    connection_id = string
    # Set to false to reference an already existing connection instead of creating it.
    create      = optional(bool, true)
    description = optional(string)
    # Roles granted on the project to the connection service account (only when create = true).
    service_account_roles = optional(list(string), ["roles/aiplatform.user"])
  })
  description = "BigQuery CLOUD_RESOURCE connection used by the remote models to call Vertex AI."
}

variable "models" {
  type = list(object({
    model_id = string
    # OPTIONS(...) of the CREATE MODEL statement. Values are raw SQL literals, e.g. "'gemini-embedding-001'".
    options = optional(map(string), {})
    # Bump to force the CREATE OR REPLACE MODEL job to run again without changing the SQL.
    revision = optional(number, 1)
  }))
  default     = []
  description = "Remote BigQuery ML models to create with CREATE OR REPLACE MODEL ... REMOTE WITH CONNECTION."
}
