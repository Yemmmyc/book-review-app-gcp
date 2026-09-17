output "network_id" {
  description = "ID of the created VPC network."
  value       = google_compute_network.vpc.id
}

output "network_name" {
  description = "Name of the created VPC network."
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "ID of the created subnetwork."
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "Name of the created subnetwork."
  value       = google_compute_subnetwork.subnet.name
}

output "private_vpc_connection" {
  description = "Reference to the private service networking connection resource for dependency management."
  value       = google_service_networking_connection.private_vpc_connection
}
