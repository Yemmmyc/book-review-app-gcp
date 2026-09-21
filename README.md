# 📚 Book Review App — Google Cloud + Terraform & CI/CD

A full-stack Book Review application deployed to **Google Cloud Platform using Terraform and Automated CI/CD**.

This project demonstrates how a containerized three-tier application can be adapted from a local Docker environment into a cloud-native architecture using managed Google Cloud services, Infrastructure as Code, private networking, secrets management, Cloud Run, and automated CI/CD pipelines.

## 🚀 Live Application

**Frontend:**  
https://book-review-frontend-90865511458.us-central1.run.app

**Backend API:**  
https://book-review-backend-90865511458.us-central1.run.app

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
```

### ☁️ Google Cloud Services

| Service | Purpose |
| --- | --- |
| **Cloud Run** | Hosts the frontend and backend serverless containers |
| **Cloud SQL** | Managed MySQL 8.0 database with private IP connectivity |
| **Artifact Registry** | Stores backend and frontend Docker images |
| **Secret Manager** | Stores database credentials and JWT secrets securely |
| **VPC Network** | Private application networking (`book-review-vpc`) |
| **Private Service Access** | Private service peering connectivity to Cloud SQL |
| **IAM & Workload Identity** | Dedicated service accounts and passwordless GitHub Actions authentication |
| **Cloud Build** | Alternative GCP-native CI/CD build pipeline |

---

## ⚙️ Automated CI/CD Pipelines

### 🔄 GitHub Actions (Primary Pipeline)

The repository uses **GitHub Actions** (`.github/workflows/deploy.yml`) as its primary automated CI/CD pipeline:

- **Trigger:** Automated execution on pushes to the `main` branch or manual `workflow_dispatch`.
- **Authentication:** Passwordless authentication to Google Cloud via **GitHub OIDC / Workload Identity Federation**.
- **Automated Testing & Build:** Executes backend unit tests (`npm test`) and compiles the frontend production build (`npm run build`).
- **Container Registry:** Builds backend and frontend Docker images tagged with `github.sha` and pushes them to Artifact Registry.
- **Infrastructure & Deployment:** Initializes Terraform using the GCS remote state backend (`backend.tf`) and deploys the Cloud Run services automatically (`terraform apply`).

### ☁️ Cloud Build Trigger (GCP-Native Alternative)

The repository also maintains an operational **Cloud Build trigger** (`cloudbuild.yaml`):

- **Trigger Name:** `book-review-main-cicd`
- **Repository:** `Yemmmyc/book-review-app-gcp`
- **Branch:** `main`
- **Configuration:** `cloudbuild.yaml`
- **Status:** Operational and automatically triggered by pushes to `main`.
- **Pipeline Strategy:** GitHub Actions is established as the primary CI/CD pipeline. Cloud Build is retained as an alternative GCP-native CI/CD option. Both pipelines share the GCS remote state file, so simultaneous Terraform deployments should be avoided to prevent state lock contention.

---

## 🛠️ Technology Stack

- **Frontend:** Next.js, React, Tailwind CSS, Axios, React Context API
- **Backend:** Node.js, Express.js, Sequelize, MySQL, JWT authentication, bcryptjs, CORS
- **DevOps / Cloud:** Docker, Docker Compose, Terraform, Google Cloud Platform (Cloud Run, Cloud SQL, Artifact Registry, Secret Manager, VPC, IAM, Cloud Build), GitHub Actions
- **Development Environment:** Google Antigravity IDE, Windows 11, PowerShell, WSL2 Ubuntu

---

## 📁 Project Structure

```text
book-review-app/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
│
├── frontend/
│   ├── Dockerfile
│   └── package.json
│
├── terraform/
│   ├── main.tf
│   ├── backend.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       ├── artifact_registry/
│       ├── secrets/
│       ├── iam/
│       ├── cloud_sql/
│       └── cloud_run/
│
├── GCP_DEPLOYMENT.md
├── cloudbuild.yaml
├── docker-compose.yml
└── README.md
```

---

## 🏠 Local Development

The application can be run locally using Docker Compose:

```bash
docker compose up --build
```

Local services:
- **Frontend:** http://localhost:3010
- **Backend API:** http://localhost:3001
- **MySQL:** localhost:3306

---

## 🏗️ Infrastructure as Code

The Google Cloud infrastructure is managed using Terraform:

- Custom VPC and regional subnet (`book-review-vpc-subnet`)
- Private Service Access peering range (`10.83.0.0/16`)
- Private Cloud SQL MySQL 8.0 instance (`10.83.0.3`)
- Artifact Registry repository (`book-review-repo`)
- Secret Manager containers for passwords and JWT tokens
- Dedicated IAM service accounts for Cloud Run tiers
- Cloud Run v2 Services with Direct VPC Egress

---

## 🔐 Security

- **Secrets Management:** Passwords and JWT secrets are injected dynamically into Cloud Run at runtime via Secret Manager references (`version = "latest"`).
- **Private Database:** Cloud SQL operates strictly on a private IP (`10.83.0.3`) without a public IPv4 address.
- **Workload Identity:** GitHub Actions authenticates via Keyless OIDC (Workload Identity Federation) without long-lived service account key files.
- **Least Privilege:** Dedicated IAM service accounts for frontend and backend workloads.

---

## 🛠️ Troubleshooting & Lessons Learned

### Cloud Run to Cloud SQL Connection Timeout

During initial Cloud Run backend deployments, the container failed startup health checks with:
`SequelizeConnectionError: connect ETIMEDOUT`

- **Observed cause:** The Cloud Run backend experienced a TCP connection timeout when Sequelize/mysql2 attempted to connect to the Cloud SQL private IPv4 address (`10.83.0.3`). Configuring the connection explicitly for IPv4 with a connection timeout resolved the deployment failure.
- **Fix:** Configured the Sequelize connection explicitly for IPv4 socket resolution and an explicit connection timeout in `backend/src/config/db.js`:
  ```javascript
  family: 4,
  connectTimeout: 10000
  ```
- **Networking Integrity:** Cloud Run VPC configuration was preserved using Direct VPC Egress with `PRIVATE_RANGES_ONLY`; no additional firewall rules or VPC redesign was required.

---

## 📌 Project Status

**Status:** Fully Deployed & Operational

- ✅ GCP Infrastructure provisioned via Terraform
- ✅ Cloud Run frontend and backend operational
- ✅ Cloud SQL operating with Private IP (`10.83.0.3`)
- ✅ Secret Manager and Artifact Registry integrated
- ✅ Primary GitHub Actions CI/CD pipeline operational
- ✅ Secondary Cloud Build trigger operational
- ✅ Live production API verified successfully