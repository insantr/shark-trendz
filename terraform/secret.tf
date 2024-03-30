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

resource "google_service_account" "cloud_run_account" {
  account_id   = "cloud-run-service-account"
  display_name = "Service account for Cloud Run"
}

resource "google_secret_manager_secret_iam_member" "default" {
  secret_id = google_secret_manager_secret.service-account-key.id
  role      = "roles/secretmanager.secretAccessor"
  # Grant the new deployed service account access to this secret.
  member     = "serviceAccount:${google_service_account.cloud_run_account.email}"
  depends_on = [google_secret_manager_secret.service-account-key]
}