# Resource block for creating a Google Cloud Storage bucket
resource "google_storage_bucket" "data_bucket" {
  # Sets the name of the bucket to the value provided in `var.gcs_bucket_name`
  name = var.gcs_bucket_name

  # Specifies the location for storing the bucket's content, using a value from `var.region`
  location = var.region

  # When set to true, allows Terraform to delete the bucket even if it contains objects.
  # This is useful for environments where buckets are dynamically created and removed.
  force_destroy = true

  # Defines the storage class of the bucket, which affects the bucket's availability and pricing.
  # The value is taken from `var.gcs_storage_class`, allowing for flexible deployment configurations.
  storage_class = var.gcs_storage_class

  # Specifies a lifecycle rule for objects within the bucket
  lifecycle_rule {
    action {
      # The action to perform when conditions are met. In this case, it's set to delete objects.
      type = "Delete"
    }
    condition {
      # The condition under which the action will be taken. Here, objects older than 30 days will be deleted.
      age = 30 # days
    }
  }
}
