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
  //name = "registry-1.docker.io/${var.docker_hub_username}/backend:1.0.0"
  name = "registry-1.docker.io/${var.docker_hub_username}/backend:1.0.0"
  build {
    context = "./DataServer"
  }
}

resource "docker_registry_image" "backend" {
  name          = docker_image.image.name
}


resource "google_cloud_run_v2_service" "backend" {
  name     = "backend"
  location = var.location

  template {
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.database_connection]
      }
    }

    containers {
      image = docker_registry_image.backend.name

      ports {
        container_port = 8080
      }

      env {
        name  = "SPRING_DATASOURCE_URL"
        //value = "jdbc:postgresql:///cloudsql:5342/${var.database_name}"
        value = "jdbc:postgresql:///${var.database_name}?socketFactory=com.google.cloud.sql.postgres.SocketFactory&cloudSqlInstance=${var.database_connection}"
        //value = "jdbc:postgresql:///${var.db_ip}:5432/${var.database_name}"

      }

      env {
        name  = "SPRING_DATASOURCE_USERNAME"
        value = var.sql_user
      }

      env {
        name  = "SPRING_DATASOURCE_PASSWORD"
        value = var.sql_password
      }

      volume_mounts {
        name = "cloudsql"
        mount_path = "/cloudsql"
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
  project = google_cloud_run_v2_service.backend.project
  location = google_cloud_run_v2_service.backend.location
  name = google_cloud_run_v2_service.backend.name
  policy_data = data.google_iam_policy.admin.policy_data
}

output "backend_url" {
  value = google_cloud_run_v2_service.backend.uri
}
  

output "backend_service" {
  value = google_cloud_run_v2_service.backend
}