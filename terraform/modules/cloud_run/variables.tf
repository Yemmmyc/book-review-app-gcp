variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP Region."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Direct VPC Egress configuration."
  type        = string
}

variable "backend_sa_email" {
  description = "Email of the Service Account for Backend Cloud Run."
  type        = string
}

variable "frontend_sa_email" {
  description = "Email of the Service Account for Frontend Cloud Run."
  type        = string
}

variable "backend_image" {
  description = "Container image URI for Backend Cloud Run service."
  type        = string
}

variable "frontend_image" {
  description = "Container image URI for Frontend Cloud Run service."
  type        = string
}

variable "db_host" {
  description = "Cloud SQL Private IP address for DB_HOST environment variable."
  type        = string
}

variable "db_name" {
  description = "Database name for DB_NAME environment variable."
  type        = string
}

variable "db_user" {
  description = "Database user for DB_USER environment variable."
  type        = string
}

variable "db_password_secret_id" {
  description = "Secret Manager Secret ID for DB_PASS."
  type        = string
}

variable "jwt_secret_id" {
  description = "Secret Manager Secret ID for JWT_SECRET."
  type        = string
}

variable "db_instance_connection_name" {
  description = "Cloud SQL connection name for Cloud SQL Proxy integration."
  type        = string
}

variable "allowed_origins" {
  description = "Comma-separated browser origins allowed to access the backend."
  type        = string
}
