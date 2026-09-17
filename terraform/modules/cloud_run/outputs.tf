output "backend_url" {
  description = "Public URL of the Backend Cloud Run service."
  value       = google_cloud_run_v2_service.backend.uri
}

output "frontend_url" {
  description = "Public URL of the Frontend Cloud Run service."
  value       = google_cloud_run_v2_service.frontend.uri
}
