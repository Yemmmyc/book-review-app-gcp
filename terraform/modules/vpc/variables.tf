variable "project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "region" {
  description = "GCP Region."
  type        = string
}

variable "vpc_name" {
  description = "Name of the custom VPC network."
  type        = string
  default     = "book-review-vpc"
}

variable "subnet_cidr" {
  description = "CIDR range for the primary subnetwork."
  type        = string
  default     = "10.0.1.0/24"
}
