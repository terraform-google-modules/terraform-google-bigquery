# Upgrading to Bigquery v1.0

The v1.0 release of BigQuery is a backwards incompatible release and has
features changes, specifically with the replacement of `table_id` and `schema_file`,
to `tables` which contains a list of maps with elements identified as `table_id`
and `schema_file`.

## Migration Instructions

This migration was performed with the following example configuration using v0.1.0 of the bigquery module.

```hcl
/// @file main.tf

provider "google" {
  version = "~> 1.20.0"
}

module "bigquery" {
  source            = "terraform-google-modules/bigquery/google"
  version           = "~> 0.1.0"
  dataset_id        = "foo"
  dataset_name      = "foo"
  description       = "some description"
  expiration        = "3600000"
  project_id        = "example-project"
  location          = "US"
  table_id          = "bar"
  schema_file       = "sample_bq_schema.json"
  time_partitioning = "DAY"
  dataset_labels    = "${var.dataset_labels }"
  table_labels      = "${var.table_labels}"
}

variable "dataset_labels" {
  description = "A mapping of labels to assign to the table"
  type        = "map"
}

variable "table_labels" {
  description = "Key value pairs in a map for table labels"
  type        = "map"
}

output "dataset_id" {
  value       = "${module.bigquery.dataset_id}"
  description = "Unique id for the dataset being provisioned"
}

output "dataset_name" {
  value       = "${module.bigquery.dataset_name}"
  description = "Friendly name for the dataset being provisioned"
}

output "dataset_project" {
  value       = "${module.bigquery.dataset_project}"
  description = "Project where the dataset and table are created"
}

output "table_id" {
  value       = "${module.bigquery.table_id}"
  description = "Unique id for the table being provisioned"
}

output "dataset_labels" {
  value       = "${module.bigquery.dataset_labels}"
  description = "Key value pairs in a map for dataset labels"
}

output "table_labels" {
  value       = "${module.bigquery.table_labels}"
  description = "Key value pairs in a map for table labels"
}
```

### Update the bigquery source

Update the BigQuery module to the v1.0 release and make the following changes to the deployment.

```diff
/// @file main.tf

provider "google" {
-  version = "~> 1.20.0"
+  version = "~> 2.5.0"
}

module "bigquery" {
  source            = "terraform-google-modules/bigquery/google"
-  version           = "~> 0.1.0"
+  version           = "~> 1.0"
  dataset_id   = "foo"
  dataset_name = "foo"
  description  = "some description"
  expiration   = "3600000"
  project_id   = "example-project"
  location     = "US"
+ tables       = "${var.tables}"
- table_id          = "bar"
- schema_file       = "sample_bq_schema.json"
  time_partitioning = "DAY"
  dataset_labels = "${var.dataset_labels }"
  table_labels   = "${var.table_labels}"
}

variable "dataset_labels" {
  description = "A mapping of labels to assign to the table"
  type        = "map"
}

variable "table_labels" {
  description = "Key value pairs in a map for table labels"
  type        = "map"
}

+variable "tables" {
+  description = "A list of table IDs that will be created on the single dataset"
+  type        = "list"

+  default = [{
+    table_id = "bar"

+    schema = "sample_bq_schema.json"
+  }]
+}

output "dataset_id" {
  value       = "${module.bigquery.dataset_id}"
  description = "Unique id for the dataset being provisioned"
}

output "dataset_name" {
  value       = "${module.bigquery.dataset_name}"
  description = "Friendly name for the dataset being provisioned"
}

output "dataset_project" {
  value       = "${module.bigquery.dataset_project}"
  description = "Project where the dataset and table are created"
}

output "table_id" {
  value       = "${module.bigquery.table_id}"
  description = "Unique id for the table being provisioned"
}

+output "table_name" {
+  value       = "${module.bigquery.table_name}"
+  description = "Friendly name for the table being provisioned"
+}

output "dataset_labels" {
  value       = "${module.bigquery.dataset_labels}"
  description = "Key value pairs in a map for dataset labels"
}

output "table_labels" {
  value       = "${module.bigquery.table_labels}"
  description = "Key value pairs in a map for table labels"
}
```

### Terraform backend
Point at the existing state file. If the deployment referencing the v1.0 module has been updated correctly, specifically the `tables` attribute, the existing dataset and table should be retained and updated in place. Outputs will be refactored to the v1.0 format.

```hcl
terraform {
   backend "gcs" {
     bucket  = "my-bucket-name"
     prefix  = "terraform/state/bigquery"
   }
}
```

### Reinitialize & apply Terraform

```
terraform init -upgrade
terraform plan
terraform apply
```

### Things to Note

#### Friendly name will be updated
Friendly name will update in place with no impact to underlying dataset or table.

```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  ~ module.bigquery.google_bigquery_table.main
      friendly_name: "" => "bar"

```

#### Output Changes
table_name, table_id & table_labels become lists and will have to be referenced as such.

```
Outputs:

dataset_id = example-project:foo
dataset_labels = {
  billable = 1
  env = dev
  owner = janesmith
}
dataset_name = foo
dataset_project = example-project
table_id = [
    example-project:foo.bar
]
table_labels = [
    {
        billable = 1,
        env = dev,
        owner = joedoe
    }
]
table_name = [
    bar
]
```
