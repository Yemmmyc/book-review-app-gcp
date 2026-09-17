output "repository_id" {
  description = "ID of the created Artifact Registry repository."
  value       = google_artifact_registry_repository.repo.repository_id
}

output "repository_url" {
  description = "URL format of the Docker repository for building and tagging images."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
}
