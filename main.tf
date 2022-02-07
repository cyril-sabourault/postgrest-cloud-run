variable "google_project_id" {
  type        = string
  default     = ""
  description = "The GCP project id to deploy to"
}


# ------- #

provider "google" {
  project = var.google_project_id

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
  project_id = var.google_project_id

  db_name_suffix = random_id.random_suffix.hex
}

module "postgres_api" {
  source     = "./cloud_run"
  project_id = var.google_project_id

  service_suffix = random_id.random_suffix.hex

  sql_connection_name         = module.postgrest_database.db_connection_name
  sql_db_username             = module.postgrest_database.db_user_name
  sql_db_password_secret_name = module.postgrest_database.db_password_secret_name
  sql_db_password             = module.postgrest_database.db_password
  sql_db_table                = module.postgrest_database.db_database_name

  depends_on = [module.postgrest_database]
}

output "postgres_api_url" {
  value = module.postgres_api.service_endpoint
}
output "sql_connection_name" {
  value = module.postgrest_database.db_connection_name
}

output "example" {
  description = "Example commands to run to add data to Cloud SQL"
  value = join("", [
    "cloud_sql_proxy -instances=${module.postgrest_database.db_connection_name}=tcp:127.0.0.1:5432 2>/dev/null &\n",
    "export _DB_PASSWORD=$(gcloud secrets versions access latest --secret ${module.postgrest_database.db_password_secret_name})\n",
    "sleep 1 && psql postgresql://${module.postgrest_database.db_user_name}:$_DB_PASSWORD@localhost:5432/${module.postgrest_database.db_database_name} < docs/petstore.sql",
    "# killall cloud_sql_proxy"
  ])
}
