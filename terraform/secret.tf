resource "google_secret_manager_secret" "service_account_key" {
  secret_id = "service-account-key"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "service_account_key_version" {
  secret      = google_secret_manager_secret.service_account_key.id
  secret_data = file(var.service_account_key_file)
}
