variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP Region."
  type        = string
}

variable "repository_id" {
  description = "ID of the Artifact Registry Docker repository."
  type        = string
  default     = "book-review-repo"
}
