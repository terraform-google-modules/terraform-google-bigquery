from google.cloud import dataform_v1beta1
import os

# Commit the notebook files to the repositories created by Terraform


def commit_repository_changes(client, project, region) -> str:
    directory = f"{os.path.dirname(__file__)}/notebooks/"
    for file in os.listdir(directory):
        with open(os.path.join(directory, file), 'rb') as f:
            encoded_string = f.read()
        file_base_name = os.path.basename(file).removesuffix(".ipynb")
        repo_id = f"projects/{project}/locations/{region}/repositories/{file_base_name}"
        print(repo_id)
        request = dataform_v1beta1.CommitRepositoryChangesRequest()
        request.name = repo_id
        request.commit_metadata = dataform_v1beta1.CommitMetadata(
            author=dataform_v1beta1.CommitAuthor(
                name="Google JSS",
                email_address="no-reply@google.com"
            ),
            commit_message="Committing Jump Start Solution notebooks"
        )
        request.file_operations = {}
        request.file_operations["content.ipynb"] = \
            dataform_v1beta1.\
            CommitRepositoryChangesRequest.\
            FileOperation(write_file=dataform_v1beta1.
                          CommitRepositoryChangesRequest.
                          FileOperation.
                          WriteFile(contents=encoded_string)
                          )
        print(request.file_operations)
        client.commit_repository_changes(request=request)
        print(f"Committed changes to {repo_id}")
    return ("Committed changes to all repos")


def run_it(request) -> str:
    dataform_client = dataform_v1beta1.DataformClient()
    project_id = os.environ.get("PROJECT_ID")
    region_id = os.environ.get("REGION")
    commit_changes = commit_repository_changes(
        dataform_client, project_id, region_id)
    print("Notebooks created!")
    return commit_changes
