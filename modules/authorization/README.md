# BigQuery Authorized Views

This submodule is used to add [authorized views](https://cloud.google.com/bigquery/docs/share-access-views#authorize_the_view_to_access_the_source_dataset).
The views that are created at another dataset are given readonly access so that even if the user does not have read access to the real dataset,
they can read data over the view.

## Background
It is possible to define authorized views while creating a dataset. However, we have a chicken&egg problem if we create all at the same time. This module has the goal of solving that.
See [basic_view](../../examples/basic_view/main.tf) as an example.

## Caveat
This module creates [bigquery_dataset_access](https://www.terraform.io/docs/providers/google/r/bigquery_dataset_access.html) resources, which conflict with the
access blocks in a [bigquery_dataset](https://www.terraform.io/docs/providers/google/r/bigquery_dataset.html) resource. Therefore, when using together with a dataset,
you should pass empty access block to the dataset.


Example:
```hcl
module "dataset" {
  source = "terraform-google-modules/bigquery/google"
  version = "~> 4.1"

  dataset_id                  = "example_dataset"
  dataset_name                = "example_dataset"
  description                 = "example description"
  project_id                  = "example-project"
  location                    = "US"

  access = [] # pass empty not to conflict with below
}

module "add_authorization" {
  source = "terraform-google-modules/bigquery/google//modules/authorization"
  version = "~> 4.1"

  dataset_id = module.dataset.bigquery_dataset.dataset_id
  project_id = module.dataset.bigquery_dataset.project

  roles = [
    {
      role           = "roles/bigquery.dataEditor"
      group_by_email = "ops@mycompany.com"
    }
  ]

  authorized_views = [
    {
      project_id = "view_project"
      dataset_id = "view_dataset"
      table_id   = "view_id"
    }
  ]
  authorized_datasets = [
    {
      project_id = "auth_dataset_project"
      dataset_id = "auth_dataset"
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authorized\_datasets | An array of datasets to be authorized on the dataset | <pre>list(object({<br>    dataset_id = string,<br>    project_id = string,<br>  }))</pre> | `[]` | no |
| authorized\_views | An array of views to give authorize for the dataset | <pre>list(object({<br>    dataset_id = string,<br>    project_id = string,<br>    table_id   = string # this is the view id, but we keep table_id to stay consistent as the resource<br>  }))</pre> | n/a | yes |
| dataset\_id | Unique ID for the dataset being provisioned. | `string` | n/a | yes |
| project\_id | Project where the dataset and table are created | `string` | n/a | yes |
| roles | An array of objects that define dataset access for one or more entities. | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| authorized\_dataset | Authorized datasets for the BQ dataset |
| authorized\_roles | Authorized roles for the dataset |
| authorized\_views | Authorized views for the dataset |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
