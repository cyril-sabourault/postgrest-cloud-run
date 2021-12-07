output "db_password_secret_name" {
  value       = regex("projects/[0-9]*/secrets/(.*)$", google_secret_manager_secret.db_postgrest_user_password_secret.name)[0]
  description = "db_password secret name"
}
