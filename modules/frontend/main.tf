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
  name = "registry-1.docker.io/${var.docker_hub_username}/frontend:1.0.0"
  build {
    context = "./frontend-app"
  }
}

resource "docker_registry_image" "frontend" {
  name          = docker_image.image.name
}

resource "google_cloud_run_v2_service" "frontend" {
  name     = "frontend"
  location = "us-central1"
  template {
    containers {
      image = docker_registry_image.frontend.name
      
      ports {
        container_port = 3000
      }

      env {
        name = "TARGET_SERVER_URL"
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
  project = google_cloud_run_v2_service.frontend.project
  location = google_cloud_run_v2_service.frontend.location
  name = google_cloud_run_v2_service.frontend.name
  policy_data = data.google_iam_policy.admin.policy_data
}

output "frontend_url" {
  value = google_cloud_run_v2_service.frontend.uri
}