variable "input_workflow_state" {
  type        = string
  description = "Name of the BigQuery ML GenAI remote model that connects to the LLM used for text generation"
  default     = null
}

variable "workflow_id" {
  type = string
  description = "The identifer of a workflow created by Terraform. Format is projects/{project ID}/locations/{region}/workflows/{workflow name}"
}

variable "polling_count" {
  type = number
  description = "Number of times the workflow status has been polled"
  default = 0
}


