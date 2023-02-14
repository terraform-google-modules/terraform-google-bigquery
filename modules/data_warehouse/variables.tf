# --------------------------------------------------
# VARIABLES
# Set these before applying the configuration
# --------------------------------------------------
variable project_id {
  type        = string
  description = "Google Cloud Project ID"
}

variable region {
  type        = string
  description = "Google Cloud Region"
}

# variable zone {
#   type        = string
#   description = "Google Cloud Zone"
# }

variable "labels" {
  type        = map(string)
  description = "A map of labels to apply to contained resources."
  default     = { "edw-bigquery" = true }
}

variable "enable_apis" {
  type        = string
  description = "Whether or not to enable underlying apis in this solution. ."
  default     = true
}
