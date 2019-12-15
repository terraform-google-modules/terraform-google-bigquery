# Upgrading to BigQuery v3.0

The v3.0 release of BigQuery is a backwards incompatible release.
- The `time_partitioning` variable has been inlined to the `table` object structure.
- The `clustering` and `expiration_time` keys were added to the `table` object structure.
- The `expiration` variable renamed to `default_table_expiration_ms`
- `count` replaced with `for_each`.
- Outputs changed to output raw resources.

## Migration Instructions

1. Rename `expiration` variable to `default_table_expiration_ms`.
```diff
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
-  version = "~> 2.0"
-  version = "~> 3.0"

- expiration = 3600000
+ default_table_expiration_ms = 3600000
....
}
```

2. Delete `time_partitioning` variable and update `tables` variable.
```diff
- time_partitioning = "DAY"
  tables = [
    {
      table_id = "foo",
      schema   = "<PATH TO THE SCHEMA JSON FILE>",
+     time_partitioning = {
+       type                     = "DAY",
+       field                    = null,
+       require_partition_filter = false,
+       expiration_ms            = null,
+     },
+     expiration_time = null,
+     clustering      = [],
      labels = {
        env      = "dev"
        billable = "true"
      },
    },
    {
      table_id = "bar",
      schema   = "<PATH TO THE SCHEMA JSON FILE>",
+     time_partitioning = {
+       type                     = "DAY",
+       field                    = null,
+       require_partition_filter = false,
+       expiration_ms            = null,
+     },
+     expiration_time = null,
+     clustering      = [],
      labels = {
        env      = "devops"
        billable = "true"
      },
    }
  ]
...
}
```

3. Replacing `count` with `for_each` requires `removing/importing` resources from/to terraform state.
Make a backup of terraform state:
```bash
terraform init
terraform state pull > state-backup.json
```
Remove table resources from the state:
```bash
terraform state rm 'module.bigquery.google_bigquery_table.main[0]'
terraform state rm 'module.bigquery.google_bigquery_table.main[1]'
...
```

Import table resources using table ids:
```bash
terraform import 'module.bigquery.google_bigquery_table.main["foo"]' '<PROJECT ID>:<DATASET ID>.foo'
terraform import 'module.bigquery.google_bigquery_table.main["bar"]' '<PROJECT ID>:<DATASET ID>.bar'
```
