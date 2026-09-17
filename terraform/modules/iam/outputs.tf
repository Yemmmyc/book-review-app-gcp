output "backend_sa_email" {
  description = "Email of the Backend Cloud Run service account."
  value       = google_service_account.backend_sa.email
}

output "frontend_sa_email" {
  description = "Email of the Frontend Cloud Run service account."
  value       = google_service_account.frontend_sa.email
}
