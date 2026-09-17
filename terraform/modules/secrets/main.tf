# Secret Manager container for database password
# Secret values are intentionally NOT stored in Terraform state.
# Populate secret versions out-of-band using:
#   gcloud secrets versions add book-review-db-password --data-file=/path/to/secret
resource "google_secret_manager_secret" "db_password" {
  secret_id = "book-review-db-password"

  replication {
    auto {}
  }
}

# Secret Manager container for JWT secret
# Populate secret versions out-of-band using:
#   gcloud secrets versions add book-review-jwt-secret --data-file=/path/to/secret
resource "google_secret_manager_secret" "jwt_secret" {
  secret_id = "book-review-jwt-secret"

  replication {
    auto {}
  }
}
