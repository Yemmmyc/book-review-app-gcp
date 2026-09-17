# Cloud SQL MySQL 8.0 Instance configured with Private IP only
resource "google_sql_database_instance" "instance" {
  name             = var.instance_name
  region           = var.region
  database_version = "MYSQL_8_0"

  # MUST wait for Private Service Access VPC peering connection to complete first
  depends_on = [var.private_vpc_connection]

  settings {
    tier              = var.tier
    availability_type = "ZONAL" # Cost-effective for dev/portfolio environment

    ip_configuration {
      ipv4_enabled    = false # Disable public IP for security
      private_network = var.vpc_id
    }

    backup_configuration {
      enabled = false # Disabled to minimize storage costs in dev
    }
  }

  deletion_protection = false # Set to false for portfolio teardown convenience
}

# MySQL Database
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

# Database User
# Password is managed out-of-band and stored in Secret Manager rather than Terraform state
resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  host     = "%"
}
