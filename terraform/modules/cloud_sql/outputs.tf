output "instance_name" {
  description = "Name of the Cloud SQL instance."
  value       = google_sql_database_instance.instance.name
}

output "connection_name" {
  description = "Connection name format (project:region:instance) used by Cloud SQL Auth Proxy."
  value       = google_sql_database_instance.instance.connection_name
}

output "private_ip_address" {
  description = "Private IP address of the Cloud SQL instance inside the VPC."
  value       = google_sql_database_instance.instance.private_ip_address
}

output "database_name" {
  description = "Name of the created MySQL database."
  value       = google_sql_database.database.name
}

output "user_name" {
  description = "Name of the created database user."
  value       = google_sql_user.user.name
}
