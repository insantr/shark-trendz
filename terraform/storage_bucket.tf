resource "google_storage_bucket" "data_bucket" {
  name          = var.gcs_bucket_name
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
