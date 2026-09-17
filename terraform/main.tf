# Root Terraform configuration orchestrating GCP infrastructure modules

# 1. Networking: Custom VPC Network, Subnet, and Private Service Access (PSA)
module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  region     = var.region
}

# 2. Container Registry: Artifact Registry repository for storing Docker images
module "artifact_registry" {
  source     = "./modules/artifact_registry"
  project_id = var.project_id
  region     = var.region
}

# 3. Secret Storage: Secret Manager containers (values injected out-of-band)
module "secrets" {
  source     = "./modules/secrets"
  project_id = var.project_id
}

# 4. Identity & Access: Service Accounts and least-privilege IAM roles
module "iam" {
  source                  = "./modules/iam"
  project_id              = var.project_id
  db_password_secret_name = module.secrets.db_password_secret_name
  jwt_secret_name         = module.secrets.jwt_secret_name
}

# 5. Database: Private Cloud SQL MySQL 8.0 Instance
module "cloud_sql" {
  source                 = "./modules/cloud_sql"
  project_id             = var.project_id
  region                 = var.region
  vpc_id                 = module.vpc.network_id
  private_vpc_connection = module.vpc.private_vpc_connection
  db_name                = var.db_name
  db_user                = var.db_user
}

# 6. Workloads: Cloud Run v2 Services with Direct VPC Egress
# Disabled by default (enable_cloud_run = false) until container images exist
module "cloud_run" {
  count                       = var.enable_cloud_run ? 1 : 0
  source                      = "./modules/cloud_run"
  project_id                  = var.project_id
  region                      = var.region
  subnet_id                   = module.vpc.subnet_id
  backend_sa_email            = module.iam.backend_sa_email
  frontend_sa_email           = module.iam.frontend_sa_email
  backend_image               = var.backend_image != "" ? var.backend_image : "${module.artifact_registry.repository_url}/backend:latest"
  frontend_image              = var.frontend_image != "" ? var.frontend_image : "${module.artifact_registry.repository_url}/frontend:latest"
  db_host                     = module.cloud_sql.private_ip_address
  db_name                     = module.cloud_sql.database_name
  db_user                     = module.cloud_sql.user_name
  db_password_secret_id       = module.secrets.db_password_secret_id
  jwt_secret_id               = module.secrets.jwt_secret_id
  db_instance_connection_name = module.cloud_sql.connection_name
  allowed_origins             = var.allowed_origins
}

