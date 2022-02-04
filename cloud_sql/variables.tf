variable "project_id" {
  default = null
}

variable "db_name_suffix" {
  default = null
}

variable "db_tier" {
  default = "db-f1-micro"
}
variable "db_version" {
  default = "POSTGRES_13"
}

variable "availability_type" {
  default = "ZONAL"
}

variable "disk_size" {
  default = "10"
}

variable "disk_type" {
  default = "PD_HDD"
}

variable "user_name" {
  default = "postgrest"
}

variable "user_host" {
  default = ""
}

variable "database_name" {
  default = "postgrest"
}
