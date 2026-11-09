# CloudForge — End-to-End DevOps Project

CloudForge is a full-stack MERN e-commerce application used to practise an end-to-end DevOps workflow.

- **Customer frontend:** React shopping interface.
- **Admin dashboard:** React administration interface.
- **Backend API:** Node.js and Express API connected to MongoDB.

> **Implementation status:** Local Docker Compose deployment and application checks are complete. AWS ECR, Jenkins, Terraform, Ansible, EKS, Kubernetes deployment, Helm, optional Argo CD, and monitoring remain to be implemented and verified.

## 1. Project definition

**Problem statement:** Automate testing, containerization, infrastructure provisioning, configuration, deployment, scaling, monitoring, and recovery of a full-stack e-commerce application using Infrastructure as Code and CI/CD practices.

**Primary deployment:** AWS using Terraform, EC2, ECR, EKS, S3, Jenkins, Ansible, Kubernetes, Prometheus, and Grafana.

**Optional extension:** Azure using Terraform and AKS if multi-cloud implementation is explicitly required.

## 2. End-to-end target architecture

The following is the proposed target architecture. Argo CD is optional. MongoDB hosting, S3 usage, ingress design, and Jenkins hosting are to be finalized during implementation.

<img width="1658" alt="CloudForge proposed end-to-end architecture" src="https://github.com/user-attachments/assets/5debde2b-685f-40b1-8350-160d068e27cf" />

| Stage | Technology | Responsibility |
|---|---|---|
| Source code | GitHub | Stores CloudForge source code |
| CI automation | Jenkins | Runs the pipeline |
| Build and test | Jenkins | Tests and builds application components |
| Containerization | Docker | Creates frontend, admin, and backend images |
| Image storage | AWS ECR | Stores Docker images |
| Infrastructure | Terraform | Provisions AWS infrastructure |
| Configuration | Ansible | Configures selected servers |
| Deployment | Kubernetes / EKS | Runs application containers |
| Packaging | Helm | Manages Kubernetes deployment configurations |
| Monitoring | Prometheus | Collects metrics |
| Visualization | Grafana | Displays monitoring dashboards |
| GitOps | Argo CD | Optional deployment synchronization |

## 3. Planned repository structure

```text
CloudForge/
├── frontend/
├── admin/
├── backend/
├── docker-compose.yml
├── terraform/
│   ├── bootstrap/
│   ├── modules/
│   │   ├── network/
│   │   └── eks/
│   └── environments/
│       ├── dev/
│       └── prod/
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   └── roles/
├── jenkins/
│   ├── Jenkinsfile.ci
│   ├── Jenkinsfile.infrastructure
│   └── Jenkinsfile.deploy
├── kubernetes/
│   ├── k8s-manifests/
│   ├── helm/charts/
│   ├── argocd/
│   └── pre-req/
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   └── alerts/
├── scripts/
├── tests/
├── docs/
└── README.md
```

This is the target organization. The Terraform, Ansible, Jenkins, Kubernetes, Helm, Argo CD, monitoring, and automation folders are planned deliverables; mark them complete only after they have been created and tested.

## 4. Project phases and sprint plan

| Sprint | Implementation |
|---|---|
| Sprint 1 | Docker, Docker Compose, GitHub, and Jenkins CI foundation |
| Sprint 2 | AWS infrastructure provisioning using Terraform |
| Sprint 3 | Ansible configuration and AWS infrastructure integration |
| Sprint 4 | ECR image publishing and EKS deployment |
| Sprint 5 | Kubernetes services, Helm, and optional Argo CD |
| Sprint 6 | Prometheus, Grafana, and alerting |
| Sprint 7 | End-to-end testing, documentation, and cost analysis |

The broader phases are application inspection; Dockerization; GitHub/Jenkins CI; AWS provisioning; Ansible configuration; ECR/EKS deployment; Helm/optional Argo CD; monitoring; end-to-end testing and cost analysis; and Azure only if multi-cloud is required. Sprint boundaries may be adjusted as implementation progresses.

## 5. Sprint 1 — Architecture, Dockerization, and Jenkins foundation

**Objective:** Prepare CloudForge for container-based deployment and establish Jenkins as the automation engine.

**Planned deliverables:** Architecture diagram, working Docker images, ECR repositories, Jenkins server, and GitHub integration.

**Implementation record:** Dockerfiles, Docker Compose deployment, service health checks, and frontend-to-backend proxy connections were implemented and verified locally. ECR repositories, Jenkins setup, and Jenkins pipeline integration remain to be completed and evidenced.

### 5.1 Inspect the application

Run these commands from the CloudForge repository root:

```powershell
git status
Get-ChildItem
Test-Path .\docker-compose.yml
docker --version
docker compose version
docker ps
```

Inspect package files and Docker configuration:

```powershell
Get-ChildItem .\frontend,.\admin,.\backend -Name package*
git diff -- .\admin\package.json
Select-String -Path .\frontend\Dockerfile,.\admin\Dockerfile,.\backend\Dockerfile -Pattern "FROM|COPY|RUN|ENV|ARG|EXPOSE|HEALTHCHECK|CMD"
Select-String -Path .\frontend\nginx\default.conf,.\admin\nginx\default.conf -Pattern "location|proxy_pass"
```

The three applications contain package and lock files required for Docker builds.

### 5.2 Docker Compose deployment

The root `docker-compose.yml` defines four services:

- `mongodb` — MongoDB 7 with a persistent named volume.
- `backend` — Express API on port `5000`.
- `frontend` — customer application on port `3000`.
- `admin` — admin application on port `3001`.

The frontend and admin Nginx configurations proxy `/api/` requests to `backend:5000`.

Validate, build, and start the stack:

```powershell
docker compose config
docker compose build
docker compose up -d
docker compose ps
```

### 5.3 Application validation

```powershell
Invoke-RestMethod http://localhost:5000/api/health
Invoke-WebRequest http://localhost:3000/ -UseBasicParsing
Invoke-WebRequest http://localhost:3001/ -UseBasicParsing
Invoke-RestMethod http://localhost:3000/api/health
Invoke-RestMethod http://localhost:3001/api/health
Invoke-RestMethod http://localhost:5000/api/products
```

### 5.4 Local test results

The following checks were completed successfully in the local Docker Compose environment:

| Check | Result |
|---|---|
| Docker Compose configuration validation | Passed |
| Custom image builds | Passed |
| MongoDB, backend, frontend, and admin containers | Healthy |
| Backend API health on port 5000 | Passed |
| Customer frontend on port 3000 | HTTP 200 |
| Admin dashboard on port 3001 | HTTP 200 |
| Customer Nginx API proxy | Passed |
| Admin Nginx API proxy | Passed |
| Products API | Returned product data |

The customer homepage displayed six products. The admin dashboard loaded its statistics and orders section; no orders were displayed, which is expected if no orders have been placed.

Local URLs:

- Customer application: <http://localhost:3000>
- Admin dashboard: <http://localhost:3001>
- Backend health: <http://localhost:5000/api/health>

### 5.5 Local application architecture

<img width="1184" alt="CloudForge Docker Compose application architecture" src="https://github.com/user-attachments/assets/12b7e8ef-20af-452d-bf15-19a42ce1a858" />

- Customer frontend: port `3000`.
- Admin dashboard: port `3001`.
- Backend API: port `5000`.
- MongoDB: Docker internal network, port `27017`.

### 5.6 Sprint 1 evidence

Local validation screenshots are stored in `Screenshots/`:

- `Screenshots/API health 1.png`
- `Screenshots/Admin dashboard API.png`
- `Screenshots/Backend connections 1 & 2.png`
- `Screenshots/Customer frontend API.png`

Additional project evidence:

<img width="546" alt="Project inspection evidence" src="https://github.com/user-attachments/assets/0451e1af-140d-4836-8c72-92d84a82e86b" />

<img width="590" alt="Project inspection evidence" src="https://github.com/user-attachments/assets/e691c8b7-dd0b-4500-82b3-1518fffde0e4" />

<img width="883" alt="Project inspection evidence" src="https://github.com/user-attachments/assets/72baef3d-144e-4db1-9cde-75bcffbb57f7" />

<img width="519" alt="Docker Compose startup evidence" src="https://github.com/user-attachments/assets/46e9e643-e9fc-42c3-84b0-ffb0fb369d91" />

<img width="872" alt="Docker Compose deployment evidence" src="https://github.com/user-attachments/assets/9f89d2ce-7098-4b10-8207-3563a38c4036" />

<img width="885" alt="Container status evidence" src="https://github.com/user-attachments/assets/0a6b0f32-2e4b-4977-b075-983b420f660d" />

<img width="915" alt="Backend health check evidence" src="https://github.com/user-attachments/assets/40d43617-555d-4b82-8ee8-22f15b62a764" />

### 5.7 Remaining Sprint 1 work

- [ ] Finalize and push README, Dockerfiles, Docker Compose configuration, Nginx configuration, and screenshots to GitHub.
- [ ] Create and verify ECR repositories.
- [ ] Set up Jenkins and secure GitHub/AWS credentials.
- [ ] Add and test the Jenkins CI pipeline.
- [ ] Capture evidence for completed architecture and automation deliverables.



