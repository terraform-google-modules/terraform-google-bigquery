from google.cloud import dataform_v1beta1
# import google.cloud.storage as gcs
# from google.cloud.storage import Blob
import json
import os
# import tempfile

# TODO: Add environment variables
# project_id = os.environ.get("PROJECT_ID")
# region = os.environ.get("REGION")
# repository_id = "thelook-learning-resources"
# gcs_file_url = os.environ.get("GCS_FILE_URL")
# dataform_client = dataform_v1beta1.DataformClient()
# tmpdir = tempfile.mkdtemp()

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


# def copy_fromgcs(gcs_file_url):
#     client = gcs.Client()
#     blob = Blob.from_string(gcs_file_url, client=client)
#     blob_name = blob.name
#     local_dest = os.path.join(tmpdir, blob_name)
#     print(f"Downloading {blob.name}")
#     blob.download_to_filename(local_dest)
#     return local_dest


def commit_repository_changes(client, repo_name, repo_id) -> None:
    # Example uses a local file that is opened, encoded, and committed
    file_name = 'Using BigFrames to Analyze BigQuery data.ipynb'
    repo_id = repo_id
    directory = os.path.dirname(__file__)
    # TODO: Add a loop here to handle multiple files as we add new notebooks
    with open(os.path.join(directory,
                           "getting_started_bq_dataframes.ipynb"), 'rb') as f:
        encoded_string = f.read()
        request = dataform_v1beta1.CommitRepositoryChangesRequest()
        request.name = repo_name
        request.commit_metadata = dataform_v1beta1.CommitMetadata(
            author=dataform_v1beta1.CommitAuthor(
                name="Google JSS",
                # TODO: Figure out what to put here
                email_address="no-reply@google.com"
            ),
            commit_message="Committing learning notebooks"
        )
        request.file_operations = {}
        request.file_operations[file_name] = dataform_v1beta1.\
            CommitRepositoryChangesRequest.FileOperation(
            write_file=dataform_v1beta1.
            CommitRepositoryChangesRequest.FileOperation.WriteFile(
                    contents=encoded_string
                )
        )
    client.commit_repository_changes(request=request)
    print(f"Committed changes to {repo_id}", )


def confirm_repo_commit(client, repo_name, repo_id) -> str:
    # Initialize request argument(s)
    repo_id = repo_id
    request = dataform_v1beta1.FetchRepositoryHistoryRequest(
        name=repo_name
    )
    # Make the request
    page_result = client.fetch_repository_history(request=request)
    # Handle the response
    for response in page_result:
        print(response)


def run_it(request):
    try:
        # project_id = os.environ.get("PROJECT_ID")
        # region = os.environ.get("REGION")
        dataform_client = dataform_v1beta1.DataformClient()
        repo_id = os.environ.get("REPO_ID")
        repo_name = "thelook_learning_resources"
        # create_repo(dataform_client, project_id, region, repo_id)
        commit_repository_changes(
            dataform_client, repo_name, repo_id)
        confirm_repo_commit(dataform_client, repo_name, repo_id)
    except Exception as e:
        return json.dumps({"errorMessage": str(e)}), 400
