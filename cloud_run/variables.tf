variable "project_id" {
  default = null
}

variable "name" {
  default = "postgrest"
}
variable "location" {
  default = "europe-west1"
}

variable "service_suffix" {
  default = null
}

variable "sql_connection_name" {
  default = null
}

variable "sql_db_username" {
  default = "postgres"
}

variable "sql_db_table" {
  default = "postgres"
}

variable "sql_db_password_secret_name" {
  default = "DB_PASSWORD"
}

variable "sql_db_password" {
  default = null
}
