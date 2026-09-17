# Dedicated Service Account for Cloud Run Backend Service
resource "google_service_account" "backend_sa" {
  account_id   = "book-review-backend-sa"
  display_name = "Cloud Run Backend Service Account"
  description  = "Identity for Express backend runtime on Cloud Run"
}

# Dedicated Service Account for Cloud Run Frontend Service
resource "google_service_account" "frontend_sa" {
  account_id   = "book-review-frontend-sa"
  display_name = "Cloud Run Frontend Service Account"
  description  = "Identity for Next.js frontend runtime on Cloud Run"
}

# Grant Cloud SQL Client role to Backend Service Account
# Allows backend application to authenticate with Cloud SQL instances.
resource "google_project_iam_member" "backend_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
}

# Grant Secret Accessor role for DB Password secret to Backend Service Account
resource "google_secret_manager_secret_iam_member" "backend_db_pass_accessor" {
  secret_id = var.db_password_secret_name
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend_sa.email}"
}

# Grant Secret Accessor role for JWT secret to Backend Service Account
resource "google_secret_manager_secret_iam_member" "backend_jwt_accessor" {
  secret_id = var.jwt_secret_name
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.backend_sa.email}"
}
