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
import time
import os


# Triggered by a change in a storage bucket
@functions_framework.cloud_event
def bq_sp_transform(cloud_event):
    tic = time.perf_counter()

    data = cloud_event.data
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
    toc = time.perf_counter()

    print(f"In {toc - tic:0.4f} seconds")

# def gcs_load_bq(cloud_event):
#     tic = time.perf_counter()

#     data = cloud_event.data
#     PROJECT_ID = os.environ.get("PROJECT_ID")
#     BUCKET_ID = os.environ.get("BUCKET_ID")

#     from google.cloud import bigquery

#     client = bigquery.Client()
#     table_id = f"{PROJECT_ID}.ds_edw.taxi_trips"
#     job_config = bigquery.LoadJobConfig(
#         source_format=bigquery.SourceFormat.PARQUET,
#     )
#     uri = f"gs://{BUCKET_ID}/{data['name']}"

#     load_job = client.load_table_from_uri(uri, table_id, job_config=job_config)  

#     load_job.result()
#     toc = time.perf_counter()

#     destination_table = client.get_table(table_id)
#     print(f"Loaded {destination_table.num_rows} rows:\n ") 
#     print(f"In {toc - tic:0.4f} seconds")
    
    
    
