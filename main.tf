locals { google_project_id = "sandbox-csabourault" }

# ------- #

provider "google" {
  project = local.google_project_id

  region = "europe-west1"
  zone   = "europe-west1-b"
}

provider "random" {}

# ------- #

resource "random_id" "random_suffix" {
  byte_length = 4
}

module "postgrest_database" {
  source     = "./cloud_sql"
  project_id = local.google_project_id

  db_name_suffix = random_id.random_suffix.hex
}

module "postgres_api" {
  source     = "./cloud_run"
  project_id = local.google_project_id

  service_suffix = random_id.random_suffix.hex

  sql_connection_name         = module.postgrest_database.db_connection_name
  sql_db_username             = module.postgrest_database.db_user_name
  sql_db_password_secret_name = module.postgrest_database.db_password_secret_name
  sql_db_password             = module.postgrest_database.db_password

  depends_on = [module.postgrest_database]
}

output "postgres_api_url" {
  value = module.postgres_api.service_endpoint
}
