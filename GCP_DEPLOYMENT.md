# Google Cloud Deployment Guide

## Overview

This document describes the Google Cloud deployment of the Book Review App using Terraform and managed Google Cloud services.

The deployment replaces the original VM-based architecture with a serverless and managed GCP architecture.

## GCP Architecture

```text
                         Internet
                            |
                            v
                 +----------------------+
                 |   Cloud Run          |
                 |   Frontend           |
                 |   Next.js            |
                 +----------+-----------+
                            |
                            | HTTPS
                            v
                 +----------------------+
                 |   Cloud Run          |
                 |   Backend            |
                 |   Node.js / Express  |
                 +----------+-----------+
                            |
                     Direct VPC Egress
                            |
                            v
                 +----------------------+
                 |    Custom VPC        |
                 |  book-review-vpc     |
                 +----------+-----------+
                            |
                            | Private IP
                            v
                 +----------------------+
                 |     Cloud SQL        |
                 |       MySQL          |
                 |  10.83.0.3           |
                 +----------------------+

        Supporting Services
        -------------------
        Artifact Registry
        Secret Manager
        IAM
        Private Service Access
        Terraform
Technology Stack
Application
Next.js
React
Tailwind CSS
Axios
Node.js
Express.js
Sequelize
MySQL
JWT
bcrypt.js
Google Cloud
Cloud Run
Cloud SQL for MySQL
Artifact Registry
Secret Manager
Virtual Private Cloud (VPC)
Private Service Access
Cloud IAM
Cloud Build
Infrastructure as Code
Terraform
HashiCorp Google Cloud Provider
GCP Project

The deployment was created in the following Google Cloud project:

Project ID: devops-portfolio-499605
Region:     us-central1

The infrastructure is managed through Terraform.

Terraform Structure
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── terraform.tfvars.example
└── modules/
    ├── artifact_registry/
    ├── cloud_run/
    ├── cloud_sql/
    ├── iam/
    ├── secrets/
    └── vpc/
Terraform Modules
VPC

Creates:

Custom VPC
Regional subnet
Private Service Access configuration
Private service networking
VPC peering route configuration
Cloud SQL

Creates:

MySQL 8.0 instance
Application database
Application database user
Private IP connectivity

The database does not use a public IPv4 address.

Cloud Run

Creates:

Backend Cloud Run service
Frontend Cloud Run service
Public Cloud Run invocation permissions
Direct VPC egress for the backend
Artifact Registry

Provides the Docker repository used to store application images.

Secret Manager

Stores application secrets such as:

Database password
JWT secret

Secret values are not stored in the Terraform configuration.

IAM

Creates dedicated service accounts for:

Backend Cloud Run service
Frontend Cloud Run service

The backend service account receives permissions required to access Cloud SQL and the application secrets.

Networking

The application uses a custom VPC:

book-review-vpc

The subnet is:

book-review-vpc-subnet

Cloud SQL uses a private IP address:

10.83.0.3

Cloud Run backend traffic to the private database is routed through Direct VPC egress.

The configuration uses:

PRIVATE_RANGES_ONLY

for Cloud Run VPC egress.

Database

The deployed database is:

Cloud SQL for MySQL
Version: MySQL 8.0
Instance: book-review-db-instance
Database: book_review_db
User: pravin
Private IP: 10.83.0.3

The database is configured without a public IPv4 address.

Secrets

Application secrets are managed through Secret Manager.

The backend receives:

DB_PASS
JWT_SECRET

The database password is supplied to Cloud Run through a Secret Manager reference rather than being hard-coded into the container image.

Container Images

Application images are stored in Artifact Registry.

Repository:

us-central1-docker.pkg.dev/devops-portfolio-499605/book-review-repo

Backend image:

book-review-backend:v1

Frontend image:

book-review-frontend:v4

The frontend image contains the production backend URL at Next.js build time through:

NEXT_PUBLIC_API_URL
Frontend Deployment

The frontend is built using Cloud Build.

The build configuration is:

frontend/cloudbuild.yaml

The Docker build receives the production backend URL as a build argument.

Example:

NEXT_PUBLIC_API_URL=https://book-review-backend-ppi2n4v6bq-uc.a.run.app

The resulting image is pushed to Artifact Registry.

Backend Deployment

The backend runs as a Cloud Run service.

Production backend:

https://book-review-backend-ppi2n4v6bq-uc.a.run.app

The backend connects to Cloud SQL through the private VPC network.

Frontend Deployment

Production frontend:

https://book-review-frontend-ppi2n4v6bq-uc.a.run.app

The frontend communicates with the backend through the production Cloud Run URL.

Terraform Deployment

From the Terraform directory:

cd terraform

Initialize Terraform:

terraform init

Review the planned changes:

terraform plan

Apply the infrastructure:

terraform apply

Confirm the deployment when prompted.

View deployment outputs:

terraform output
Application Verification

The production deployment was verified through the following tests:

Frontend
Homepage loads successfully
Book catalogue displays correctly
Book titles and ratings are readable
Login page loads correctly
Register page loads correctly
Authentication
User registration succeeds
User login succeeds
JWT authentication flow works
Successful login redirects to the homepage
Backend

The backend API was tested through:

/api/books

The API successfully returned book data from Cloud SQL.

Database Connectivity

Cloud Run successfully connected to the private Cloud SQL instance through the VPC.

Troubleshooting
Cloud Run PORT Error

Cloud Run rejected an explicitly configured PORT environment variable because PORT is reserved by Cloud Run.

The explicit application PORT environment variable was removed from the Terraform configuration.

Cloud Run supplies the PORT environment variable automatically.

Database Authentication Failure

The backend initially failed with a MySQL authentication error.

The database password stored in Secret Manager was regenerated and synchronized with the Cloud SQL application user.

The Cloud Run backend was then redeployed using the correct secret version.

Cloud Run to Cloud SQL Timeout

The backend initially started successfully but could not reach the private Cloud SQL address.

The VPC configuration was verified and a VPC peering route configuration was added:

google_compute_network_peering_routes_config

This enabled the required private service networking routes.

After the change, the backend successfully connected to Cloud SQL.

Frontend Showing No Books

The frontend initially loaded but displayed no books.

The backend was responding correctly, but the frontend-to-backend browser request was affected by CORS configuration.

The backend was configured with:

ALLOWED_ORIGINS

using the production frontend URL.

After redeployment, the frontend successfully retrieved and displayed the books.

Security Considerations

The deployment uses several security controls:

Cloud SQL does not expose a public IPv4 address.
Database access occurs through private networking.
Database credentials are stored in Secret Manager.
JWT secrets are stored in Secret Manager.
Dedicated service accounts are used for Cloud Run.
Backend permissions are separated from frontend permissions.
Database passwords are not baked into Docker images.
Local environment files are excluded from Git.
Terraform state files are excluded from Git.
Cost Considerations

The Cloud SQL instance uses a small development-oriented machine tier:

db-f1-micro

Cloud Run services can scale down when they are not receiving traffic.

The deployment should still be monitored for Google Cloud charges, particularly Cloud SQL, which remains an active managed database service.

Cleanup

When the environment is no longer required, Terraform can remove the managed infrastructure:

cd terraform
terraform destroy

Review the proposed resources carefully before confirming the destruction.

Deployment Result

The final deployment successfully demonstrated:

Terraform
   |
   +-- Custom VPC
   |
   +-- Private Service Access
   |
   +-- Cloud SQL MySQL
   |
   +-- Secret Manager
   |
   +-- Artifact Registry
   |
   +-- IAM Service Accounts
   |
   +-- Cloud Run Backend
   |
   +-- Cloud Run Frontend

The application was successfully tested in production with working:

Book catalogue
User registration
User authentication
Backend API
Private database connectivity