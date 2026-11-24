module "ml_models" {
  source = "../../modules/ml_models"

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
