# BigQuery ML Remote Models

This submodule is used to create [BigQuery ML remote models](https://cloud.google.com/bigquery/docs/reference/standard-sql/bigqueryml-syntax-create-remote-model)
on Vertex AI endpoints, together with the BigQuery connection they use.

Terraform has no resource for BigQuery ML models, so each model is created by running a
`CREATE OR REPLACE MODEL ... REMOTE WITH CONNECTION ...` statement as a BigQuery job. The module:

1. Creates a `CLOUD_RESOURCE` connection, or uses an existing one.
2. Grants the connection service account `roles/aiplatform.user` and waits for the IAM change to propagate.
3. Runs the `CREATE OR REPLACE MODEL` job for every model.
4. Checks the job result and fails the apply (and every later plan) when the model was not created.

Example:
```hcl
module "ml_models" {
  source = "github.com/extenda/terraform-google-bigquery//modules/ml_models"

  project_id = "example-project"
  dataset_id = "example_dataset" # Existing dataset, in the same location
  location   = "EU"

  connection = {
    connection_id = "vertex-ai"
  }

  models = [
    {
      model_id = "embeddings"
      options = {
        endpoint = "'gemini-embedding-001'"
      }
    }
  ]
}
```

Use the model, for example:
```sql
SELECT *
FROM ML.GENERATE_EMBEDDING(
  MODEL `example-project.example_dataset.embeddings`,
  (SELECT 'Hello world' AS content),
  STRUCT(768 AS output_dimensionality)
);
```

## Notes

- The dataset must exist, in the same location as `location`.
- Requires Terraform >= 1.3 and Google provider >= 6.0. Use it as a separate Terraform configuration
  (e.g. a Terragrunt unit) from the root module of this repository, which still requires Google provider < 5.0.
- The job id is derived from the statement and `revision`. Changing the options, or bumping `revision`,
  runs `CREATE OR REPLACE MODEL` again.
- Destroying the module deletes the connection, but not the model. The model is removed when its dataset
  is destroyed, or manually with `DROP MODEL`.
- When `connection.create = false`, the service account of the existing connection must already have access to Vertex AI.
- Every call to the model is billed by Vertex AI.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| connection | BigQuery CLOUD\_RESOURCE connection used by the remote models to call Vertex AI. | <pre>object({<br>    connection_id         = string<br>    create                = optional(bool, true)<br>    description           = optional(string)<br>    service_account_roles = optional(list(string), ["roles/aiplatform.user"])<br>  })</pre> | n/a | yes |
| dataset\_id | The (existing) dataset the models are created in. | `string` | n/a | yes |
| location | Location of the connection and the model jobs. Must match the dataset location. | `string` | `"EU"` | no |
| models | Remote BigQuery ML models to create with CREATE OR REPLACE MODEL ... REMOTE WITH CONNECTION. | <pre>list(object({<br>    model_id = string<br>    options  = optional(map(string), {})<br>    revision = optional(number, 1)<br>  }))</pre> | `[]` | no |
| project\_id | The project where the connection and models are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| connection\_id | Fully qualified connection id (project.location.connection\_id). |
| connection\_service\_account | Service account of the created connection. |
| models | Fully qualified ids of the created models. |
