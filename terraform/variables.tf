#variable "credentials" {
#  description = "My Credentials"
#  default     = "./keys/my-cred.json"
#  #ex: if you have a directory where this file is called keys with your service account json file
#  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
#}

locals {
  data_lake_bucket = "shark-trendz_data_lake"
  #  docker_image_url = "${var.region}-docker.pkg.dev/${var.project}/${var.repository}/mageai:latest"
}


variable "project" {
  type        = string
  description = "The name of the project"
  default     = "shark-trendz"
}

variable "region" {
  description = "Region"
  default = "europe-southwest1"
}

variable "location" {
  description = "Project Location"
  default = "EU"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "shark-trendz-data-lake"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "mage-data-prep"
}

variable "container_cpu" {
  description = "Container cpu"
  default     = "2000m"
}

variable "container_memory" {
  description = "Container memory"
  default     = "2G"
}

variable "zone" {
  type        = string
  description = "The default compute zone"
  default     = "europe-southwest1-a"
}

variable "repository" {
  type        = string
  description = "The name of the Artifact Registry repository to be created"
  default     = "mage-data-prep"
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
  default     = "mageuser"
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
  default     = "mageuser"
}

variable "docker_image" {
  type        = string
  description = "The Docker image url in the Artifact Registry repository to be deployed to Cloud Run"
  default     = "europe-southwest1-docker.pkg.dev/shark-trendz/mage-data-prep/mageai:latest"
}

variable "domain" {
  description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
  type        = string
  default     = ""
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = false
}

variable "service_account_key_file" {
  description = "Patch to JSON file google service account"
  type        = string
}