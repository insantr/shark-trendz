# Defines a resource for creating a dataset in Google BigQuery
resource "google_bigquery_dataset" "default" {
  # Specifies the dataset ID, with its value taken from Terraform variables
  dataset_id = var.bigquery_dataset_name

  # Provides a description for the dataset for identification purposes
  description = "dataset description"

  # Specifies the geographic location where the dataset is stored
  location = var.region

  # Assigns labels to the dataset for resource management, such as for billing grouping or indicating data sensitivity
  labels = {
    billing_group = "accounting",
    pii           = "sensitive"
  }
}

## Defines a resource for creating a table within the BigQuery dataset
#resource "google_bigquery_table" "default" {
#  # References the dataset ID where the table will be created
#  dataset_id = google_bigquery_dataset.default.dataset_id
#
#  # Specifies the table ID, with its value taken from Terraform variables
#  table_id = var.bigquery_table_name
#
#  # Disables deletion protection for the table
#  deletion_protection = false
#
#  # Configures time partitioning for the table on a yearly basis based on the "Date" field
#  time_partitioning {
#    type  = "YEAR"
#    field = "Date"
#  }
#
#  # Describes the table's schema in JSON format within a multiline string block
#  schema = <<EOF
#[
#  {
#    "name": "Date",
#    "type": "TIMESTAMP",
#    "description": "Datetime incident"
#  },
#  {
#    "name": "Type",
#    "type": "STRING",
#    "description": "Type of incident"
#  },
#  {
#    "name": "Country",
#    "type": "STRING"
#  },
#  {
#    "name": "Sex",
#    "type": "STRING"
#  }
#]
#EOF
#
#}
