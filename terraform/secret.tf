resource "google_secret_manager_secret" "service-account-key" {
  secret_id = "service-account-key"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "service-account-key-version" {
  secret      = google_secret_manager_secret.service-account-key.name
  secret_data = file(var.service_account_key_file)
}

resource "google_secret_manager_secret_iam_member" "default" {
  secret_id = google_secret_manager_secret.service-account-key.id
  role      = "roles/secretmanager.secretAccessor"
  member     = "allUsers"
  depends_on = [google_secret_manager_secret.service-account-key]
}