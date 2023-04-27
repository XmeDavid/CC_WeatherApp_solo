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
  name = "registry-1.docker.io/${var.docker_hub_username}/external:1.0.0"
  build {
    context = "./external-collector"
  }
}

resource "docker_registry_image" "external" {
  name          = docker_image.image.name
}


resource "google_cloud_run_v2_job" "external" {
  name     = "cloudrun-job"
  location = "us-central1"
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = docker_registry_image.external.name
        command = [ "npm","start"]
        env {
          name = "WEATHER_API_KEY"
          value = var.weather_api_key
        }
        env {
          name = "WEATHER_API_URL"
          value = var.weather_api_url
        }
        env {
          name = "TARGET_SERVER_URL"
          value = var.target_server_url
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}


resource "google_cloud_scheduler_job" "fetch" {
  name        = "external-collector"
  description = "Fetches data from external API"
  schedule    = "0 0 * * *"

  
  http_target {
    http_method = "POST"
    uri         = "https://us-central1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/cc-solo-project/jobs/${google_cloud_run_v2_job.external.name}:run"
    body        = base64encode("")
  }
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/editor"
    members = [
      "user:2220658@my.ipleiria.pt",
    ]
  }
}

resource "google_cloud_run_v2_job_iam_policy" "policy" {
  project = google_cloud_run_v2_job.external.project
  location = google_cloud_run_v2_job.external.location
  name = google_cloud_run_v2_job.external.name
  policy_data = data.google_iam_policy.admin.policy_data
}

output "external_url" {
  value = google_cloud_run_v2_job.external.id
}
output "external_name" {
  value = google_cloud_run_v2_job.external.name
}
