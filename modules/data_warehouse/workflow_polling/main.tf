data "google_client_config" "current" {
}

locals {
  is_active = var.input_workflow_state == null || var.input_workflow_state == "FAILED" ? "no" : "yes"
}

## Trigger the execution of the setup workflow with an API call
data "http" "call_workflows_setup" {
  url    = "https://workflowexecutions.googleapis.com/v1/${var.workflow_id}/executions"
  method = local.is_active == "no" ? "POST" : "GET"
  request_headers = {
    Accept = "application/json"
  Authorization = "Bearer ${data.google_client_config.current.access_token}" }
}

## If the workflow last failed, sleep for 30 seconds before checking the workflow execution status.
## If last execution did not fail, exit as quickly as possible (1 second)
resource "time_sleep" "workflow_execution_wait" {
  create_duration = local.is_active == "no" ? "30s" : "1s"
  depends_on = [
    data.http.call_workflows_setup,
  ]
}

## Check the state of the setup workflow execution with an API call
data "http" "call_workflows_state" {
  url    = "https://workflowexecutions.googleapis.com/v1/${var.workflow_id}/executions"
  method = "GET"
  request_headers = {
    Accept = "application/json"
  Authorization = "Bearer ${data.google_client_config.current.access_token}" }
  depends_on = [
    data.http.call_workflows_setup,
    time_sleep.workflow_execution_wait
  ]
}

## Parse out the workflow execution state from the API call response
locals {
  response_body = data.http.call_workflows_state.response_body
  workflow_state = local.response_body.executions[0].state
  depends_on = [
    time_sleep.workflow_execution_wait,
    data.http.call_workflows_state
  ]
}

## Output the workflow state to use as input for subsequent invocations
output workflow_state {
  value = local.workflow_state
}

## If workflow execution is actively running, sleep for 90 seconds to allow it to finish
## If not, exit as quickly as possible (1 second)
resource "time_sleep" "complete_workflow" {
  create_duration = local.workflow_state == "ACTIVE" ? "90s" : "1s"
  depends_on = [
    data.http.call_workflows_setup,
    time_sleep.workflow_execution_wait,
    data.http.call_workflows_state,
    local.workflow_state
  ]
}
