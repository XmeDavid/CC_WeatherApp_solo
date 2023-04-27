terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.58.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "google" {
    credentials = file(var.credentials_path)
    project     = var.project_id
    region      = var.region
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address = "registry-1.docker.io"
    username = var.docker_hub_username
    password = var.docker_hub_password
  }
}

module "database" {
    source = "./modules/database"
    docker_hub_username = var.docker_hub_username
    docker_hub_password = var.docker_hub_password
    docker_hub_email    = var.docker_hub_email
}

module "backend" {
    source              = "./modules/backend"
    docker_hub_username = var.docker_hub_username
    docker_hub_password = var.docker_hub_password
    docker_hub_email    = var.docker_hub_email
    database_name       = module.database.database_name
    database_connection = module.database.database_connection
    sql_user            = module.database.sql_user
    sql_password        = module.database.sql_password
    db_ip               = module.database.db_ip
}

module "frontend" {
    source              = "./modules/frontend"
    docker_hub_username = var.docker_hub_username
    docker_hub_password = var.docker_hub_password
    docker_hub_email    = var.docker_hub_email
    target_server_url   = module.backend.backend_url
    backend_service = module.backend.backend_service
}

module "external" {
    source              = "./modules/external"
    docker_hub_username = var.docker_hub_username
    docker_hub_password = var.docker_hub_password
    docker_hub_email    = var.docker_hub_email
    target_server_url   = module.backend.backend_url
}

module "collector" {
    source              = "./modules/collector"
    docker_hub_username = var.docker_hub_username
    docker_hub_password = var.docker_hub_password
    docker_hub_email    = var.docker_hub_email
    target_server_url   = module.backend.backend_url
}

output "frontend_url" {
    value = module.frontend.frontend_url
}

output "external_url" {
  value = module.external.external_url
}

output "collector_url" {
  value = module.collector.collector_url
}

output "backend_url" {
  value = module.backend.backend_url
}

output "database_connection" {
  value = module.database.database_connection
}

output "database_name" {
  value = module.database.database_name
}
