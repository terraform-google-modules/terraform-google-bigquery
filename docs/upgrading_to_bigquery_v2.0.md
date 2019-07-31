# Upgrading to BigQuery v2.0

The v2.0 release of BigQuery is a backwards incompatible release. The `table_labels` variable has been inlined to the `table` object structure and the supported version of Terraform is 0.12.

## Migration Instructions

In the previous release, table labels were provided once for all tables:

```hcl
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 1.0"

  tables = [
    {
      table_id = "foo"
      schema   = "foo.json"
    },
    {
      table_id = "bar"
      schema   = "bar.json
    }
  ]

  table_labels = {
    key = "value"
  }

  # ...
}
```

In the new release, table labels are provided per table:

```hcl
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 2.0"

  tables = [
    {
      table_id = "foo"
      schema   = "foo.json"
      labels   = {
        key = "value"
      }
    },
    {
      table_id = "bar"
      schema   = "bar.json
      labels   = {
        key = "value"
      }
    }
  ]

  # ...
}
```
