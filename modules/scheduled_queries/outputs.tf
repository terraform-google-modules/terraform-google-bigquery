output "query_name" {
  value = concat(
    values({ for k, v in google_bigquery_data_transfer_config.query_config : k => v.name }),
  )

  description = "The resource name of the transfer config"
}
