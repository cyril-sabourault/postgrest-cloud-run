resource "google_sql_database_instance" "postgrest" {
  name             = "postgrest-${var.db_name_suffix}"
  database_version = var.db_version

  # deletion_protection = false

  settings {
    tier              = var.db_tier
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_type         = var.disk_type

    ip_configuration {
      ipv4_enabled = true
      # Can also change to private and add vpc connector to cloud run service
    }
  }
}

resource "random_password" "postgrest_password" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "google_sql_user" "postgres_user" {
  name     = var.user_name
  instance = google_sql_database_instance.postgrest.name
  host     = var.user_host
  password = random_password.postgrest_password.result
}

module "secretmanager" {
  source = "../secret_manager"

  secret_name  = format("%s-%s", "DB_PASSWORD", var.db_name_suffix)
  secret_value = random_password.postgrest_password.result
}
