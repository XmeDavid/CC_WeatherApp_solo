variable "docker_hub_username" {
  type = string
}
variable "docker_hub_password" {
  type = string
}
variable "docker_hub_email" {
  type = string
}


variable "sql_user" {
  type = string
  default = "sql_user"
}
variable "sql_password" {
  type = string
  default = "changeme"
}