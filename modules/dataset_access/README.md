# terraform-google-bigquery_dataset_access

Configure BigQuery dataset access.

Supports preserving special groups, managing roles with JSON, and adding view permissions.

The `google_bigquery_dataset` resource authoritatively sets permissions thus removing special groups if not explicitly set.

Role management can be done using JSON and view access circumvents cyclical references issues in the current provider version.

*Note:* Roles set using this module *are authoritative*.

## Usage

**Preserving special groups:**

Reduces need to redundantly add all special groups back onto a dataset. To keep "special groups" simply set `preserve_special_groups` to `true`.

This will add projectOwners, projectWriters, and projectReaders to the dataset.

```hcl
module "private_project_access" {
  source = "github.com/terraform-google-bigquery_dataset_access"
  project = "my-project"
  dataset_id = "my-dataset"

  preserve_special_groups = true
}
```

**JSON defined roles:**

Roles can be defined using JSON for programmatic generation of access permissions.

JSON structure is an list of maps using the same keys and structure as the [`bq CLI`](https://cloud.google.com/bigquery/docs/bq-command-line-tool).

A role ACL entry must have the key `role` with a value of `OWNER`, `READER`, or `WRITER` and one of the following keys: `userByEmail`, `domain`, or `groupByEmail`.

```json
[
  {
    "role": "OWNER",
    "userByEmail": "admin@foo.com"
  },
  {
    "role": "READER",
    "domain": "foo.com"
  },
  {
    "role": "WRITER",
    "groupByEmail": "editors@foo.com"
  }
]
```

```hcl
module "private_project_access" {
  source = "github.com/terraform-google-bigquery_dataset_access"
  project = "my-project"
  dataset_id = "my-dataset"

  preserve_special_groups = true
  roles_json = "${file("./roles.json")}"
}
```

**Defining view permission:**

View access in the `google_bigquery_dataset` resource causes a [cyclical reference](https://github.com/terraform-providers/terraform-provider-google/issues/2686) between the dataset and the view.

This module takes the dataset and the views information to set the access so that neither of those resources themselves need to refer to one another.

```hcl
module "private_project_access" {
  source = "github.com/terraform-google-bigquery_dataset_access"
  project = "my-project"
  dataset_id = "my-dataset"

  views = [
    {
      project = "view-project"
      dataset = "view-dataset"
      table = "view-table"
    }
  ]
}
```

`views`, `roles`, and `preserve_special_groups` may also be used together.

## Dependencies

`bigquery_dataset_access` uses `null_resource` to make calls to BigQuery through the `bq` CLI tool.

Note: This assumes the `gcloud` CLI [has been initialized](https://github.com/terraform-google-cli) with rights to the target dataset project.

## Usage with `terraform-google-cli`

```hcl
module "cli" {
  source   = "github.com/terraform-google-cli"
}

module "private_project_access" {
  source = "github.com/terraform-google-bigquery_dataset_access"ess"
  project = "my-project"
  dataset_id = "my-dataset"

  # Specify the path to the bq binary
  bq_path = "${module.cli.bq}"

  preserve_special_groups = true
  roles_json = "${file("./roles.json")}"
  views = [
    {
      project = "${google_bigquery_dataset.public.project}"
      dataset = "${google_bigquery_dataset.public.dataset_id}"
      table   = "${google_bigquery_table.v_hourly.table_id}"
    },
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bq\_path | Path to bq CLI; Defaults to `bq` | string | `bq` | no |
| dataset\_id | Dataset ID of dataset to add permissions to | string | - | yes |
| platform | Platform to target | string | `linux` | no |
| preserve\_special\_groups | Preserve special group permissions. Defaults to true. | string | `true` | no |
| project | Project ID of dataset to add permissions to | string | - | yes |
| roles\_json | Path to a JSON file of access roles.<br><br>JSON structure is an list of maps using the same keys and structure as the [`bq CLI`](https://cloud.google.com/bigquery/docs/bq-command-line-tool).<br><br>A role ACL entry must have the key `role` with a value of `OWNER`, `READER`, or `WRITER` and one of the following keys: `userByEmail`, `domain`, or `groupByEmail`.<br><br>``` [   {     "role": "OWNER",     "userByEmail": "admin@foo.com"   },   {     "role": "READER",     "domain": "foo.com"   },   {     "role": "WRITER",     "groupByEmail": "editors@foo.com"   } ] ``` | string | - | yes |
| views | List of view permissions. Each entry must consist of `project`, `dataset`, and `table` receiving access. | list | - | yes |
