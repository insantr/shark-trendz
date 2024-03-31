resource "google_bigquery_dataset" "default" {
  dataset_id                      = var.bigquery_dataset_name
#  default_partition_expiration_ms = 2592000000  # 30 days
#  default_table_expiration_ms     = 31536000000 # 365 days
  description                     = "dataset description"
  location                        = "EU"
#  max_time_travel_hours           = 96 # 4 days

  labels = {
    billing_group = "accounting",
    pii           = "sensitive"
  }
}

resource "google_bigquery_table" "default" {
  dataset_id          = google_bigquery_dataset.default.dataset_id
  table_id            = var.bigquery_table_name
  deletion_protection = false # set to "true" in production

  time_partitioning {
    type          = "YEAR"
    field         = "Date"
#    expiration_ms = 432000000 # 5 days
  }
#  require_partition_filter = true

  schema = <<EOF
[
  {
    "name": "Date",
    "type": "TIMESTAMP",
    "description": "Datetime incident"
  },
  {
    "name": "Type",
    "type": "STRING",
    "description": "Type of incident"
  },
  {
    "name": "Country",
    "type": "STRING"
  },
  {
    "name": "Sex",
    "type": "STRING"
  }
]
EOF

}