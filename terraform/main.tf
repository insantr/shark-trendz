terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.3"
    }
  }
}

provider "google" {
  #  credentials = file(var.credentials) # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
  project = var.project
  region  = var.region
#  zone    = var.zone
}

# Create a service account for my-service
resource "google_service_account" "my_service" {
  account_id   = "my-service"
  display_name = "My Service service account"
}

# Set permissions on service account
resource "google_project_iam_binding" "my_service" {
  project = var.project

  for_each = toset([
    "run.invoker",
    "secretmanager.secretAccessor",
    "cloudsql.admin",
    "bigquery.admin",
  ])

  role       = "roles/${each.key}"
  members    = ["serviceAccount:${google_service_account.my_service.email}"]
  depends_on = [google_service_account.my_service]
}