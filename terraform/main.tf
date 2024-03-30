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


#resource "google_bigquery_dataset" "shark_dataset" {
#  dataset_id = var.bq_dataset_name
#  location   = var.location
#}