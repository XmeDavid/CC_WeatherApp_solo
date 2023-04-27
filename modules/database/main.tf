resource "google_sql_database" "database" {
  name     = "database"
  instance = google_sql_database_instance.instance.name
}


resource "google_sql_database_instance" "instance" {
  name             = "database-instance"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "false"
}

resource "google_sql_user" "users" {
  name     = var.sql_user
  instance = google_sql_database_instance.instance.name
  password = var.sql_password
}

output "database_name" {
  value = google_sql_database.database.name
}

output "database_connection" {
  value = google_sql_database_instance.instance.connection_name
}

output "sql_user" {
  value = var.sql_user
}

output "sql_password" {
  value = var.sql_password
}

output "db_ip" {
  value = google_sql_database_instance.instance.public_ip_address
}