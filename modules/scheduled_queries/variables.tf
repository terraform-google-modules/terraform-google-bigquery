variable "project_id" {
  description = "Project where scheduled queries are created"
  type        = string
}

variable "query_config" {
  description = "Data transfer configuration for creating scheduled queries"
  type        = list(any)
  default     = []
}
