# BigQuery Authorized Datasets, Views and Routines

This submodule is used to add [authorized datasets](https://cloud.google.com/bigquery/docs/authorized-datasets), [authorized views](https://cloud.google.com/bigquery/docs/share-access-views#authorize_the_view_to_access_the_source_dataset) and [authorized routines](https://cloud.google.com/bigquery/docs/authorized-functions).
An `authorized dataset` lets you authorize all of the views in a specified dataset to access the data in a second dataset. An `authorized view` lets you share query results with particular users and groups without giving them access to the underlying source data. `Authorized Routine (Function)` let you share query results with particular users or groups without giving those users or groups access to the underlying tables

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
  version = "~> 7.0"

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
| authorized\_routines | An array of authorized routine to be authorized on the dataset | <pre>list(object({<br>    project_id = string,<br>    dataset_id = string,<br>    routine_id = string<br>  }))</pre> | `[]` | no |
| authorized\_views | An array of views to give authorize for the dataset | <pre>list(object({<br>    dataset_id = string,<br>    project_id = string,<br>    table_id   = string # this is the view id, but we keep table_id to stay consistent as the resource<br>  }))</pre> | `[]` | no |
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
