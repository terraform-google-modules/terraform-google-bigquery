output "ds_friendly_name" {
  value = "blah" #google_bigquery_dataset.ds_edw.friendly_name
}

output "function_uri" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}

output "lookerstudio_report_url" {
  value       = "https://lookerstudio.google.com/reporting/create?c.reportId=402d64d6-2a14-45a1-b159-0dcc88c62cd5&ds.ds0.datasourceName=vw_taxi&ds.ds0.projectId=${var.project_id}&ds.ds0.type=TABLE&ds.ds0.datasetId=ds_edw&ds.ds0.tableId=vw_taxi"
  description = "The URL to create a new Looker Studio report displays a sample dashboard for the taxi data analysis"
}
