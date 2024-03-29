terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.3"
    }
  }
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "shark-trendz-organization"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "shark-trendz-workspace"
    }
  }
}

provider "google" {
  #  credentials = file(var.credentials) # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
  project = var.project
  region  = var.region
  zone    = var.zone
}


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



#resource "google_bigquery_dataset" "shark_dataset" {
#  dataset_id = var.bq_dataset_name
#  location   = var.location
#}