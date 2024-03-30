resource "google_storage_bucket" "data_bucket" {
  name          = "shark-trendz-data-lake"
  location      = var.region
  force_destroy = true
  storage_class = var.gcs_storage_class


  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 # days
    }
  }
}
