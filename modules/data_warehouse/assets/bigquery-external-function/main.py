# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START functions_cloudevent_storage]
import functions_framework
import os


# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def bq_sp_transform(cloud_event):

    data = cloud_event.data
    
    gcs_export_bq()

    gcs_copy()
    
    bq_one_time_sp()


def bq_one_time_sp():

    PROJECT_ID = os.environ.get("PROJECT_ID")

    from google.cloud import bigquery

    client = bigquery.Client()

    query_string = f"""
        CALL `{PROJECT_ID}.ds_edw.sp_provision_lookup_tables`();
        CALL `{PROJECT_ID}.ds_edw.sp_lookerstudio_report`();
        CALL `{PROJECT_ID}.ds_edw.sp_bigqueryml_model`();
        """
    query_job = client.query(query_string)

    query_job.result()


def gcs_export_bq():

    from google.cloud import bigquery
    client = bigquery.Client()
    EXPORT_BUCKET_ID = os.environ.get("EXPORT_BUCKET_ID")
    PROJECT_ID = os.environ.get("PROJECT_ID")

    destination_uri = "gs://{}/{}".format(EXPORT_BUCKET_ID, "taxi-*.Parquet")
    job_config = bigquery.job.ExtractJobConfig()
    job_config.compression = bigquery.Compression.GZIP
    job_config.destination_format = "PARQUET"

    extract_job = client.extract_table(
       'bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022',
        destination_uri,
        # Location must match that of the source table.
        location="US",
        job_config=job_config,
    )  # API request
    extract_job.result()  # Waits for job to complete.

def gcs_copy():

    EXPORT_BUCKET_ID = os.environ.get("EXPORT_BUCKET_ID")
    BUCKET_ID = os.environ.get("BUCKET_ID")

    from google.cloud import storage

    storage_client = storage.Client()

    source_bucket = storage_client.bucket(EXPORT_BUCKET_ID)
    destination_bucket = storage_client.bucket(BUCKET_ID)

    blobs = storage_client.list_blobs(EXPORT_BUCKET_ID)

    blob_list = []
    # Note: The call returns a response only when the iterator is consumed.
    for blob in blobs:
        blob_list.append(blob.name)
        print(blob.name)

    for blob in blob_list:
        source_blob = source_bucket.blob(blob)

        blob_copy = source_bucket.copy_blob(
            source_blob, destination_bucket, blob,
        )