variable "docker_hub_username" {
  type = string
}
variable "docker_hub_password" {
  type = string
}
variable "docker_hub_email" {
  type = string
}

variable "weather_api_key" {
  type = string
  default = "d89c3a8c80e2eef84569cea3f4578d11"
}
variable "weather_api_url" {
  type = string
  default = "https://api.openweathermap.org/data/2.5/weather"
}

variable "target_server_url" {
  type = string
}