variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP Region."
  type        = string
}

variable "vpc_id" {
  description = "VPC Network ID for Private IP attachment."
  type        = string
}

variable "private_vpc_connection" {
  description = "Explicit dependency reference for Private Service Access peering connection."
  type        = any
}

variable "instance_name" {
  description = "Cloud SQL Instance Name."
  type        = string
  default     = "book-review-db-instance"
}

variable "db_name" {
  description = "Name of the MySQL database."
  type        = string
  default     = "book_review_db"
}

variable "db_user" {
  description = "Database username."
  type        = string
  default     = "pravin"
}

variable "tier" {
  description = "Cloud SQL machine type tier."
  type        = string
  default     = "db-f1-micro"
}
