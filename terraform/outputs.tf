# Root infrastructure outputs

output "vpc_name" {
  description = "Name of the custom VPC network."
  value       = module.vpc.network_name
}

output "subnet_name" {
  description = "Name of the subnetwork created for Direct VPC Egress."
  value       = module.vpc.subnet_name
}

output "artifact_registry_repo_url" {
  description = "URL of the Artifact Registry Docker repository."
  value       = module.artifact_registry.repository_url
}

output "db_instance_connection_name" {
  description = "Connection name of the Cloud SQL instance."
  value       = module.cloud_sql.connection_name
}

output "db_private_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = module.cloud_sql.private_ip_address
}

output "backend_sa_email" {
  description = "Email of the Backend Service Account."
  value       = module.iam.backend_sa_email
}

output "frontend_sa_email" {
  description = "Email of the Frontend Service Account."
  value       = module.iam.frontend_sa_email
}

output "backend_url" {
  description = "Public URL of the Backend Cloud Run service (when enable_cloud_run = true)."
  value       = var.enable_cloud_run ? module.cloud_run[0].backend_url : "Cloud Run deployment disabled (enable_cloud_run = false)"
}

output "frontend_url" {
  description = "Public URL of the Frontend Cloud Run service (when enable_cloud_run = true)."
  value       = var.enable_cloud_run ? module.cloud_run[0].frontend_url : "Cloud Run deployment disabled (enable_cloud_run = false)"
}
