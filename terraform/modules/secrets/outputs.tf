output "db_password_secret_id" {
  description = "Secret ID for DB password in Secret Manager."
  value       = google_secret_manager_secret.db_password.secret_id
}

output "jwt_secret_id" {
  description = "Secret ID for JWT secret in Secret Manager."
  value       = google_secret_manager_secret.jwt_secret.secret_id
}

output "db_password_secret_name" {
  description = "Full resource name of the DB password secret."
  value       = google_secret_manager_secret.db_password.name
}

output "jwt_secret_name" {
  description = "Full resource name of the JWT secret."
  value       = google_secret_manager_secret.jwt_secret.name
}
