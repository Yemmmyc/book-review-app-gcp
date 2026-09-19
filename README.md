# 📚 Book Review App — Google Cloud + Terraform

A full-stack Book Review application deployed to **Google Cloud Platform using Terraform**.

This project demonstrates how a containerized three-tier application can be adapted from a local Docker environment into a cloud-native architecture using managed Google Cloud services, Infrastructure as Code, private networking, secrets management, and Cloud Run.

## 🚀 Live Application

**Frontend:**  
https://book-review-frontend-ppi2n4v6bq-uc.a.run.app

The application supports:

- User registration
- User authentication
- Book browsing
- Book details
- Reviews and ratings
- REST API communication between frontend and backend

---

## 🏗️ Architecture

```text
                         Internet
                            │
                            ▼
                ┌───────────────────────┐
                │     Cloud Run         │
                │      Frontend         │
                │      Next.js          │
                └───────────┬───────────┘
                            │
                            │ HTTPS
                            ▼
                ┌───────────────────────┐
                │     Cloud Run         │
                │       Backend         │
                │   Node.js / Express   │
                └───────────┬───────────┘
                            │
                     Direct VPC Egress
                            │
                            ▼
             ┌──────────────────────────────┐
             │       Custom VPC             │
             │                              │
             │  Private Service Access      │
             │          │                   │
             │          ▼                   │
             │   ┌────────────────────┐     │
             │   │     Cloud SQL      │     │
             │   │       MySQL        │     │
             │   │    Private IP      │     │
             │   └────────────────────┘     │
             └──────────────────────────────┘

       ┌──────────────────┐
       │  Secret Manager  │
       │ DB Password      │
       │ JWT Secret       │
       └────────┬─────────┘
                │
                ▼
          Cloud Run Backend

       ┌──────────────────┐
       │ Artifact Registry│
       │ Docker Images    │
       └──────────────────┘
☁️ Google Cloud Services
Service	Purpose
Cloud Run	Hosts the frontend and backend containers
Cloud SQL	Managed MySQL database
Artifact Registry	Stores container images
Secret Manager	Stores database and JWT secrets
VPC Network	Private application networking
Private Service Access	Private connectivity to Cloud SQL
IAM	Service accounts and least-privilege access
Cloud Build	Container image builds
🛠️ Technology Stack
Frontend
Next.js
React
Tailwind CSS
Axios
React Context API
Backend
Node.js
Express.js
Sequelize
MySQL
JWT authentication
bcrypt.js
CORS
DevOps / Cloud
Docker
Docker Compose
Terraform
Google Cloud Platform
Cloud Run
Cloud SQL
Artifact Registry
Secret Manager
VPC
IAM
Cloud Build
Git / GitHub
Development Environment
Google Antigravity IDE
Windows 11
PowerShell
WSL2 Ubuntu
📁 Project Structure
book-review-app/
│
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── ...
│
├── frontend/
│   ├── Dockerfile
│   ├── cloudbuild.yaml
│   ├── package.json
│   └── ...
│
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   │
│   └── modules/
│       ├── vpc/
│       ├── artifact_registry/
│       ├── secrets/
│       ├── iam/
│       ├── cloud_sql/
│       └── cloud_run/
│
├── GCP_DEPLOYMENT.md
├── docker-compose.yml
├── .gitignore
└── README.md
🏠 Local Development

The application can be run locally using Docker Compose.

Start the application
docker compose up --build

The local services are:

Service	URL
Frontend	http://localhost:3010
Backend API	http://localhost:3001
MySQL	localhost:3306
Verify the backend
curl http://localhost:3001/api/books
🏗️ Infrastructure as Code

The Google Cloud infrastructure is managed using Terraform.

Terraform provisions:

Custom VPC
VPC subnet
Private Service Access
Cloud SQL
Artifact Registry
Secret Manager secrets
IAM service accounts
Cloud Run services

The infrastructure is modularized to make individual components easier to maintain and reuse.

Terraform workflow
terraform init
terraform validate
terraform plan
terraform apply

To remove the infrastructure:

terraform destroy

Sensitive Terraform files such as terraform.tfvars and Terraform state files are excluded from Git.

🔐 Security

Security was considered throughout the cloud deployment.

Secrets

Application secrets are stored in Google Secret Manager rather than committed to Git.

The repository does not contain:

Database passwords
JWT secrets
Terraform state
Production .env files
Terraform variable files containing sensitive values
Database

Cloud SQL is configured with:

Private IP
No public IP
Private Service Access
Cloud Run private network connectivity
IAM

Dedicated service accounts are used for the Cloud Run services.

The backend service account receives only the permissions required for:

Cloud SQL connectivity
Secret Manager access
Network

Cloud Run uses Direct VPC egress to reach the private Cloud SQL instance.

🧪 Application Verification

The deployed application was tested end-to-end.

Verified functionality includes:

✅ Frontend successfully deployed to Cloud Run
✅ Backend successfully deployed to Cloud Run
✅ Cloud Run → VPC connectivity
✅ Cloud Run → private Cloud SQL connectivity
✅ Database authentication
✅ Seeded book data retrieval
✅ CORS configuration
✅ User registration
✅ User login
✅ API communication
✅ Secret Manager integration
🐳 Containerization

Both application tiers are containerized independently.

Frontend Container
       │
       ▼
Cloud Run Frontend

Backend Container
       │
       ▼
Cloud Run Backend

Container images are stored in Google Artifact Registry.

📖 Deployment Documentation

Detailed deployment documentation is available in:

GCP_DEPLOYMENT.md

It covers:

Google Cloud project configuration
Terraform deployment
VPC networking
Private Service Access
Cloud SQL
Secret Manager
Artifact Registry
Cloud Run
Cloud Build
Troubleshooting
Security considerations
Cost considerations
Infrastructure cleanup
🧠 Key DevOps Lessons

This project provided hands-on experience with:

Infrastructure as Code using Terraform
Modular Terraform design
Google Cloud networking
Private database connectivity
Cloud Run networking
Container image management
Secret management
IAM service accounts
Cloud SQL
Application troubleshooting
CORS configuration
Docker-based local development
Git history and secret cleanup
Cloud deployment troubleshooting
🔄 Deployment Flow
Developer
    │
    ▼
GitHub
    │
    ▼
Terraform
    │
    ├──────────────► VPC
    │
    ├──────────────► Cloud SQL
    │
    ├──────────────► Secret Manager
    │
    ├──────────────► Artifact Registry
    │
    └──────────────► Cloud Run
                           │
                           ▼
                     Live Application
📌 Project Status

Status: Deployed and operational

The application is currently deployed on Google Cloud with:

Cloud Run frontend
Cloud Run backend
Private Cloud SQL
Secret Manager
Artifact Registry
Terraform-managed infrastructure
Next Phase

Planned DevOps improvements include:

GitHub Actions CI/CD
Automated testing
Automated container builds
Automated Artifact Registry publishing
Automated Cloud Run deployment
Deployment environment separation
👩🏽‍💻 Project

Repository:
https://github.com/Yemmmyc/book-review-app-gcp

Primary cloud platform: Google Cloud Platform

Infrastructure: Terraform

Development environment: Google Antigravity IDE