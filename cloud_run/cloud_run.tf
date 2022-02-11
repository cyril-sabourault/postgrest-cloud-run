resource "google_cloud_run_service" "postgrest" {
  name     = "${var.name}-${var.service_suffix}"
  location = var.location

  template {
    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = var.sql_connection_name,
        "autoscaling.knative.dev/maxScale"      = "100"
      }
    }
    spec {
      service_account_name = data.google_compute_default_service_account.default_compute.email

      containers {
        image = "eu.gcr.io/${var.project_id}/postgrest"

        ports {
          container_port = 3000
        }

        env {
          name = "PGRST_DB_URI"
          value_from {
            secret_key_ref {
              name = var.sql_db_password_secret_name
              key  = "latest"
            }
          }
        }
        env {
          name  = "PGRST_DB_SCHEMA"
          value = "public"
        }
        env {
          name  = "PGRST_DB_ANON_ROLE"
          value = var.sql_db_username
        }
      }
    }
  }


  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
      metadata.0.annotations,
    ]
  }
}

# IAM NOAUTH
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  service  = google_cloud_run_service.postgrest.name
  location = google_cloud_run_service.postgrest.location

  policy_data = data.google_iam_policy.noauth.policy_data
}

data "google_compute_default_service_account" "default_compute" {}
