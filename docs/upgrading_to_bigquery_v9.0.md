# Upgrading to BigQuery v9.0

- The supported provider has been updated to v5.3 ([terraform-provider-google/releases/tag/v5.3.0](https://github.com/hashicorp/terraform-provider-google/releases/tag/v5.3.0))
- `require_partition_filter` has been deprecated under the `time_partitioning` block and can be used at the top level with the same name instead. (hashicorp/terraform-provider-google#16238)

## Migration Instructions

In the previous release, `require_partition_filter` was a part of the `time_partitioning` block on a `materialized_views` object.

    ```hcl
    module "bigquery" {
      source  = "terraform-google-modules/bigquery/google"
      version = "~> 8.0"
      ....
      materialized_views = [
        {
          view_id = "foo",
          ....
          time_partitioning  = {
            ....
            require_partition_filter = true,
            ....
          },
        }
      ],
    ...
    }
    ```

In the new release, `require_partition_filter` is a top-level field in the `materialized_views` object.

    ```hcl
    module "bigquery" {
      source  = "terraform-google-modules/bigquery/google"
      version = "~> 9.0"
      ....
      materialized_views = [
        {
          view_id = "foo",
          ....
          require_partition_filter = true,
          time_partitioning  = {
            ....
          },
        },
      ],
    ...
    }
    ```
