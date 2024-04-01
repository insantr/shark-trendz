# Define local variables for easy reuse throughout the Terraform configuration
locals {
  # Name of the data lake bucket in GCS
  data_lake_bucket = "shark-trendz_data_lake"
  # Fully qualified Docker image name including the region, project, repository, and tag
  docker_image = "${var.region}-docker.pkg.dev/${var.project}/${var.repository}/mageai:${var.docker_image_tag}"
}

# Define variables with descriptions, types, and default values

variable "project" {
  type        = string
  description = "The GCP project ID."
  default     = "shark-trendz"
}

variable "region" {
  description = "The GCP region where resources will be created."
  default     = "europe-southwest1"
}

variable "gcs_bucket_name" {
  description = "Name of the Google Cloud Storage bucket for the data lake."
  default     = "shark-trendz-data-lake"
}

variable "gcs_storage_class" {
  description = "Storage class of the GCS bucket (e.g., STANDARD, NEARLINE)."
  default     = "STANDARD"
}

variable "app_name" {
  type        = string
  description = "Name of the application for which resources are provisioned."
  default     = "mage-data-prep"
}

variable "container_cpu" {
  description = "The amount of CPU allocated for the container, in millicores (e.g., '2000m' for 2 cores)."
  default     = "2000m"
}

variable "container_memory" {
  description = "The amount of memory allocated for the container (e.g., '2G' for 2 GiB)."
  default     = "2G"
}

variable "repository" {
  type        = string
  description = "Name of the Artifact Registry repository where Docker images are stored."
  default     = "mage-data-prep"
}

variable "database_user" {
  type        = string
  description = "Username for accessing the PostgreSQL database."
  default     = "mageuser"
}

variable "database_password" {
  type        = string
  description = "Password for the PostgreSQL database user."
  sensitive   = true
  default     = "mageuser"
}

variable "docker_image_tag" {
  type        = string
  description = "Tag of the Docker image to be deployed."
  default     = "latest"
}

variable "domain" {
  description = "The domain name for the load balancer, used when SSL is enabled."
  type        = string
  default     = ""
}

variable "ssl" {
  description = "Whether to enable SSL for the load balancer. If true, a managed SSL certificate is provisioned."
  type        = bool
  default     = false
}

variable "service_account_key_file" {
  description = "Path to the JSON file containing the Google service account credentials."
  type        = string
  default     = "/home/secret/gcp_credential.json"
}

variable "bigquery_dataset_name" {
  description = "Name of the BigQuery dataset to be used."
  type        = string
  default     = "shark_trendz_dataset"
}