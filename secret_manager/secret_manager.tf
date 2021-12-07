resource "google_secret_manager_secret" "db_postgrest_user_password_secret" {
  secret_id = var.secret_name

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version_latest" {
  secret      = google_secret_manager_secret.db_postgrest_user_password_secret.id
  secret_data = var.secret_value
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  secret_id = google_secret_manager_secret.db_postgrest_user_password_secret.id

  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

data "google_project" "project" {}
