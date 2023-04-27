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

resource "docker_image" "image" {
  name = "registry-1.docker.io/${var.docker_hub_username}/collector:1.0.0"
  build {
    context = "./collector-api"
  }
}

resource "docker_registry_image" "collector" {
  name          = docker_image.image.name
}

resource "google_cloud_run_v2_service" "collector" {
  name     = "collector"
  location = "us-central1"
  template {
    containers {
      
      image = docker_registry_image.collector.name
      
      ports {
        container_port = 4200
      }
      env {
        name = "SERVER_URL"
        value = var.target_server_url
      }
    }
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/editor"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "policy" {
  project = google_cloud_run_v2_service.collector.project
  location = google_cloud_run_v2_service.collector.location
  name = google_cloud_run_v2_service.collector.name
  policy_data = data.google_iam_policy.admin.policy_data
}

output "collector_url" {
  value = google_cloud_run_v2_service.collector.uri
}