# Introduces a delay of 30 seconds before creating the following resources.
# This can be useful for managing dependencies that are not explicitly recognized by Terraform.
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

# Creates an Artifact Registry Repository for Docker containers.
# Artifact Registry is a scalable and secure repository for container images and other artifacts.
resource "google_artifact_registry_repository" "my_docker_repo" {
  location      = var.region                   # Specifies the geographic location of the repository.
  repository_id = var.repository               # The ID of the repository, typically defined in Terraform variables.
  description   = "My docker repository"       # A brief description of the repository's purpose or contents.
  format        = "DOCKER"                     # Sets the repository format to DOCKER for container images.
  depends_on    = [time_sleep.wait_30_seconds] # Ensures a delay before creating this repository.
}

# Creates a service account named 'docker-pusher' intended for pushing Docker containers to the Artifact Registry.
resource "google_service_account" "docker_pusher" {
  account_id   = "docker-pusher"              # Unique identifier for the service account.
  display_name = "Docker Container Pusher"    # Human-readable name for the service account.
  depends_on   = [time_sleep.wait_30_seconds] # Waits for the specified duration before creation.
}

# Grants the 'docker-pusher' service account permissions to write to the Artifact Registry repository.
# This is necessary for the service account to push Docker images to the repository.
resource "google_artifact_registry_repository_iam_member" "docker_pusher_iam" {
  location   = google_artifact_registry_repository.my_docker_repo.location
  repository = google_artifact_registry_repository.my_docker_repo.repository_id
  role       = "roles/artifactregistry.writer"                                # Assigns the 'writer' role, allowing image upload.
  member     = "serviceAccount:${google_service_account.docker_pusher.email}" # Specifies the service account.
  depends_on = [
    google_artifact_registry_repository.my_docker_repo,
    google_service_account.docker_pusher
  ]
}
