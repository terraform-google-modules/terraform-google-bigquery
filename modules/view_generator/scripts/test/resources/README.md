# BigQuery View Builder
This script reads a BigQuery Schema JSON file and genereates a SQL query defining a view
that scrubs a list of blacklisted fields. The blacklisted fields will be removed even
if they are children fields of a nested struct.

# Dependencies.
This script depends on the `gcloud` CLI instead of the python client libraries for 
simple deployment with TFE, which will already have `gcloud`. 

## Running the Tests.
From this scripts directory run:
```
python -m unittest test.test_bigquery_view_generator
```
