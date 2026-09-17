variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "db_password_secret_name" {
  description = "Full resource name of the DB password secret in Secret Manager."
  type        = string
}

variable "jwt_secret_name" {
  description = "Full resource name of the JWT secret in Secret Manager."
  type        = string
}
