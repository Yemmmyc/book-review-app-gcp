# Input variables for root module

variable "project_id" {
  description = "The GCP project ID to deploy infrastructure into."
  type        = string
  default     = "devops-portfolio-499605"
}

variable "region" {
  description = "The primary GCP region for regional resources."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Deployment environment identifier (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "Name of the Cloud SQL MySQL database."
  type        = string
  default     = "book_review_db"
}

variable "db_user" {
  description = "Username for the Cloud SQL MySQL database user."
  type        = string
  default     = "pravin"
}

variable "enable_cloud_run" {
  description = "Flag to enable Cloud Run service deployment. Set to true after container images are pushed to Artifact Registry."
  type        = bool
  default     = true
}

variable "backend_image" {
  description = "Full Docker image URI for the backend Cloud Run service."
  type        = string
  default     = ""
}

variable "frontend_image" {
  description = "Full Docker image URI for the frontend Cloud Run service."
  type        = string
  default     = ""
}

variable "allowed_origins" {
  description = "Comma-separated browser origins allowed to access the backend."
  type        = string
}
