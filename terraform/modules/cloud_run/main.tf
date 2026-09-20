# Cloud Run v2 Backend Service (Express Node.js)
resource "google_cloud_run_v2_service" "backend" {
  name     = "book-review-backend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    service_account = var.backend_sa_email
  
    # Direct VPC Egress configuration (Native Cloud Run v2 feature)
    # Routes egress traffic through the VPC subnet to access private Cloud SQL IP without a VPC Access Connector
    vpc_access {
      network_interfaces {
        subnetwork = var.subnet_id
      }
      egress = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = var.backend_image

      ports {
        container_port = 3001
      }

      env {
        name  = "DB_HOST"
        value = var.db_host
      }

      env {
        name  = "DB_NAME"
        value = var.db_name
      }

      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "ALLOWED_ORIGINS"
        value = var.allowed_origins
      }

      env {
        name = "DB_DIALECT"
        value = "mysql"
      }

      # Inject DB password from Secret Manager securely at runtime
      env {
        name = "DB_PASS"
        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_id
            version = "3"
          }
        }
      }

      # Inject JWT Secret from Secret Manager securely at runtime
      env {
        name = "JWT_SECRET"
        value_source {
          secret_key_ref {
            secret  = var.jwt_secret_id
            version = "latest"
          }
        }
      }
    }
  }
}

# Cloud Run v2 Frontend Service (Next.js)
resource "google_cloud_run_v2_service" "frontend" {
  name     = "book-review-frontend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    service_account = var.frontend_sa_email

    containers {
      image = var.frontend_image

      ports {
        container_port = 3000
      }
    }
  }
}

# Allow unauthenticated public HTTP access to the Frontend service
resource "google_cloud_run_v2_service_iam_member" "frontend_public_access" {
  location = google_cloud_run_v2_service.frontend.location
  name     = google_cloud_run_v2_service.frontend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
resource "google_cloud_run_v2_service_iam_member" "backend_public_access" {
  location = google_cloud_run_v2_service.backend.location
  name     = google_cloud_run_v2_service.backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
