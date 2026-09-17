# Custom VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Primary Subnet used for Direct VPC Egress from Cloud Run
resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.vpc_name}-subnet"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Private Service Access (PSA) - Reserved IP Allocation Range for Private Cloud SQL
# Allocate an internal IP range within the VPC for Google service peering.
resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.vpc_name}-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

# Service Networking Connection
# Establishes VPC peering between the custom VPC and Google Managed Services network (servicenetworking.googleapis.com).
# MUST complete before creating private Cloud SQL instances.
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
resource "google_compute_network_peering_routes_config" "private_service_routes" {
  peering              = google_service_networking_connection.private_vpc_connection.peering
  network              = google_compute_network.vpc.name
  import_custom_routes = true
  export_custom_routes = true
}