# Artifact Registry repository for storing backend and frontend Docker container images
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker container image repository for Book Review App"
  format        = "DOCKER"
}
