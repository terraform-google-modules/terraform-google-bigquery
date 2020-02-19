# Upgrading to BigQuery v4.0

The v4.0 release of BigQuery is a backwards incompatible release.
- The supported provider has been updated to v3.0.
- Add support for setting custom access. The default has been changed to be more
  secure.
- The UDFS submodule has been isolated from the main module.
- Trimmed outputs and made their names more consistent.

## Access

The major logic change in this release is a new default for the `access` field.

Datasets are created with the following
[default](https://cloud.google.com/bigquery/docs/reference/rest/v2/datasets):


> If unspecified at dataset creation time, BigQuery adds default dataset access for the following entities: access.specialGroup: projectReaders; access.role: READER; access.specialGroup: projectWriters; access.role: WRITER; access.specialGroup: projectOwners; access.role: OWNER; access.userByEmail: [dataset creator email]; access.role: OWNER;

The problematic default is
`access.userByEmail: [dataset creator email]; access.role: OWNER`.
This will subtly grant owner access to the creating user and leave that access
on, even if the access to the project, etc is revoked.

The new default will only set
`specialGroup: projectOwners; access.role: roles/bigquery.admin`. This is done
because the BigQuery API requires at least one owner on the dataset, and this is
the safest and most generic owner that can be granted.

Do note that standard GCP IAM logic still apply to bigquery datasets.
For example, setting an IAM role at the project level will inherit to all
datasets within the project.

## Migration Instructions

1. Upgrade version
```diff
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
-  version = "~> 3.0"
+  version = "~> 4.0"
....
}
```

2. Set access to an empty slice if you wish to preserve existing behaviour
```diff
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
+ access = []
...
}
```

3. Move add_udf field to its own module call
```diff
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
- add_udfs: true
...
}

+ module "add_udfs" {
+  source = ""terraform-google-modules/bigquery/google//modules/udf"
+  version = "~> 4.0"
+  dataset_id = module.bigquery.bigquery_dataset.dataset_id
+  project_id = module.bigquery.bigquery_dataset.project
}
```

4. Adjust output references

- The following outputs have been deleted:
  - dataset_labels
  - table_labels
  - added_udfs
- The following outputs have been renamed:
  - data_project -> project
  - table_id -> table_ids
  - table_name -> table_names

See https://www.terraform.io/docs/configuration/outputs.html#accessing-child-module-outputs
on how to adjust your usage.
