from google.cloud import dataform_v1beta1
import os

# Initialize request argument(s)
# def create_repo(client, project_id, region, repo_id) -> None:
#     request = dataform_v1beta1.CreateRepositoryRequest(
#         parent=f"projects/{project_id}/locations/{region}",
#         repository_id=repo_id,
#         repository=dataform_v1beta1.Repository(
#             # Required. This is your notebook name in BQ Studio
#             display_name="BigFrames sample notebook 2",
#             labels={
#                 "single-file-asset-type": "notebook",
#                 "data-warehouse": "true"
#             },
#             set_authenticated_user_admin=True
#         )
#     )
#     response = client.create_repository(request=request)
#     repo_fqn = response.name
#     print(f"Created repository: {repo_fqn}")


def commit_repository_changes(client, project_id, region_id) -> str:
    # Example uses a local file that is opened, encoded, and committed
    directory = f"{os.path.dirname(__file__)}/notebooks/"
    for file in os.listdir(directory):
        with open(os.path.join(directory, file), 'rb') as f:
            encoded_string = f.read()
        file_base_name = os.path.basename(file).removesuffix(".ipynb")
        repo_id = f"projects/{project_id}/locations/{region_id}/\
            repositories/{file_base_name}"
        print(repo_id)
        request = dataform_v1beta1.CommitRepositoryChangesRequest()
        request.name = repo_id
        request.commit_metadata = dataform_v1beta1.CommitMetadata(
            author=dataform_v1beta1.CommitAuthor(
                name="Google JSS",
                # TODO: Figure out what to put here
                email_address="no-reply@google.com"
            ),
            commit_message="Committing learning notebooks"
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


# def confirm_repo_commit(client, repo_id) -> None:
#     # Initialize request argument(s)
#     repo_id = repo_id
#     request = dataform_v1beta1.FetchRepositoryHistoryRequest(
#         name=repo_id
#     )
#     # Make the request
#     page_result = client.fetch_repository_history(request=request)
#     # Handle the response
#     response_list = []
#     for response in page_result:
#         print(response)
#         response_list.append(response)


def run_it(request) -> str:
    dataform_client = dataform_v1beta1.DataformClient()
    project_id = os.environ.get("PROJECT_ID")
    region_id = os.environ.get("REGION_ID")
    # create_repo(dataform_client, project_id, region, repo_id)
    commit_changes = commit_repository_changes(
        dataform_client, project_id, region_id)
    print("Notebooks created!")
    return commit_changes
