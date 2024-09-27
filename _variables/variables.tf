variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The database admin username"
  type        = string
}

variable "db_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true
}
