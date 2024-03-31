# Creates a new secret in Google Secret Manager to store the service account key.
resource "google_secret_manager_secret" "service-account-key" {
  # The ID to assign to the secret. This ID must be unique within the project.
  secret_id = "service-account-key"

  # Configures the replication policy for the secret. Setting `automatic` to true 
  # means the secret's value will be automatically replicated across Google-managed
  # storage locations, ensuring high availability.
  replication {
    automatic = true
  }
}

# Adds a version of the secret with the actual secret data.
# Secret versions allow you to keep multiple versions of a secret's value over time.
resource "google_secret_manager_secret_version" "service-account-key-version" {
  # References the secret created above by its name.
  secret = google_secret_manager_secret.service-account-key.name

  # The data for this version of the secret. Here, it reads the contents of a file 
  # whose path is specified in the `service_account_key_file` variable. This file
  # should contain the JSON key for a Google service account.
  secret_data = file(var.service_account_key_file)
}
