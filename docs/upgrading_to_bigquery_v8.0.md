# Upgrading to BigQuery v8.0

The v8.0 release of BigQuery is a backwards incompatible release.

- The supported provider has been updated to v5.3
- `require_partition_filter` has been deprecated under the `time_partitioning`
  block and can be used at the top level with the same name instead.

## Migration Instructions

1. Upgrade version

```diff
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
-  version = "~> 7.0"
+  version = "~> 8.0"
....
}
```

2. Remove `require_partition_filter` from within the `time_partitioning` block
   and set it at the top level, if required.

```diff
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  ....
  tables = [
    {
      ....
+     require_partition_filter = true,
      time_partitioning  = {
        ....
-       require_partition_filter = true,
        ....
      },
      ....
    }
  ]
...
}
```
