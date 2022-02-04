output "db_user_name" {
  value       = google_sql_user.postgres_user.name
  description = "db username (default: postgrest)"
}
output "db_database_name" {
  value       = var.database_name
  description = "db database name (default: postgrest)"
}

output "db_password_secret_name" {
  value       = module.secretmanager.db_password_secret_name
  description = "db_password secret name"
}

output "db_password" {
  value       = random_password.postgrest_password.result
  description = "db_password value"
}

output "db_connection_name" {
  value       = google_sql_database_instance.postgrest.connection_name
  description = "db connection name"
}
