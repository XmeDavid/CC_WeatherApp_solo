variable "docker_hub_username" {
  type = string
}
variable "docker_hub_password" {
  type = string
}
variable "docker_hub_email" {
  type = string
}

variable "location" {
  type = string
  default = "us-central1"
}

variable "database_connection" {
  type = string
}

variable "database_name" {
  type = string
}

variable "sql_user" {
  type = string
}

variable "sql_password" {
  type = string
}

variable "db_ip" {
  type = string
}