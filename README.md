# CloudForge --- End-to-End DevOps Project

CloudForge is a full-stack MERN e-commerce application used to practise
an end-to-end DevOps workflow.

-   **Customer frontend:** React shopping interface.
-   **Admin dashboard:** React administration interface.
-   **Backend API:** Node.js and Express API connected to MongoDB.

> **Status:** Docker Compose deployment and local application checks are
> complete. AWS, Jenkins, Terraform, Ansible, EKS, Helm, Argo CD, and
> monitoring remain planned until deployed and validated.

## 1. Project definition

**Problem statement:** Automate testing, containerization,
infrastructure provisioning, configuration, deployment, scaling,
monitoring, and recovery of a full-stack e-commerce application using
Infrastructure as Code and CI/CD practices.

**Primary target:** AWS using Terraform, EC2, ECR, EKS, S3, Jenkins,
Ansible, Kubernetes, Prometheus, and Grafana.

**Optional extension:** Azure using Terraform and AKS, if multi-cloud
implementation is explicitly required.

## 2. Target architecture

``` text
Developer
   |
   v
GitHub repository
   |
   v
Jenkins CI/CD
   |-- Checkout source
   |-- Build and test application
   |-- Build Docker images
   |-- Publish images
   v
Amazon ECR
   |
   v
Amazon EKS
   |-- Customer frontend
   |-- Admin dashboard
   |-- Backend API
   |-- MongoDB (hosting choice to be finalized)
   |
   +--> Ingress / Load Balancer --> Application users

Terraform --> AWS infrastructure
Ansible   --> Configuration of selected EC2 hosts
Helm      --> Kubernetes application packaging
Argo CD   --> Optional GitOps deployment
Prometheus + Grafana + alerts --> Monitoring
S3       --> State and/or project artifacts (purpose to be finalized)
```

This is the intended architecture, not a claim that all cloud resources
have been created. MongoDB hosting, S3 usage, ingress design, and
Jenkins hosting must be finalized before cloud deployment.

## 3. Planned repository structure

``` text
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

This is the target organization. Mark folders and files complete only
after they have been created and tested.

## 4. Project phases

  Phase   Scope
  ------- -------------------------------------------------------
  1       Inspect the application
  2       Dockerize frontend, admin, and backend
  3       Set up GitHub and Jenkins CI
  4       Provision AWS infrastructure with Terraform
  5       Configure selected servers with Ansible
  6       Publish images to ECR and deploy to EKS
  7       Add Helm and, if required, Argo CD
  8       Configure Prometheus, Grafana, and alerts
  9       Test the pipeline, document results, and analyze cost
  10      Add Azure only if multi-cloud is required

## 5. Sprint 1 --- Foundation and Docker Compose

**Objective:** Prepare CloudForge for container-based deployment and
establish the foundation for automation.

**Sprint 1 deliverables:** Architecture diagram, working Docker images,
ECR repositories, Jenkins server, and GitHub integration. Local Docker
implementation is complete; ECR, Jenkins, and GitHub integration remain
to be completed and evidenced.

### 5.1 Inspect the application

Run from the repository root:

``` powershell
git status
Get-ChildItem
Test-Path .\docker-compose.yml
docker --version
docker compose version
docker ps
Get-ChildItem .\frontend,.\admin,.\backend -Name package*
git diff -- .\admin\package.json
Select-String -Path .\frontend\Dockerfile,.\admin\Dockerfile,.\backend\Dockerfile -Pattern "FROM|COPY|RUN|ENV|ARG|EXPOSE|HEALTHCHECK|CMD"
Select-String -Path .\frontend\nginx\default.conf,.\admin\nginx\default.conf -Pattern "location|proxy_pass"
```

The three applications contain package and lock files required for
Docker builds.

### 5.2 Build and start the stack

The root `docker-compose.yml` defines four services:

-   `mongodb` --- MongoDB 7 with a persistent named volume.
-   `backend` --- Express API on port `5000`.
-   `frontend` --- customer application on port `3000`.
-   `admin` --- admin application on port `3001`.

The frontend and admin Nginx configurations proxy `/api/` requests to
`backend:5000`.

``` powershell
docker compose config
docker compose build
docker compose up -d
docker compose ps
```

### 5.3 Application validation

``` powershell
Invoke-RestMethod http://localhost:5000/api/health
Invoke-WebRequest http://localhost:3000/ -UseBasicParsing
Invoke-WebRequest http://localhost:3001/ -UseBasicParsing
Invoke-RestMethod http://localhost:3000/api/health
Invoke-RestMethod http://localhost:3001/api/health
Invoke-RestMethod http://localhost:5000/api/products
```

### 5.4 Local test results

The following checks were completed successfully in the local Docker
Compose environment:

  Check                                              Result
  -------------------------------------------------- -----------------------
  Docker Compose configuration validation            Passed
  Custom image builds                                Passed
  MongoDB, backend, frontend, and admin containers   Healthy
  Backend API health on port 5000                    Passed
  Customer frontend on port 3000                     HTTP 200
  Admin dashboard on port 3001                       HTTP 200
  Customer Nginx API proxy                           Passed
  Admin Nginx API proxy                              Passed
  Product API response                               Returned product data

Local URLs:

-   Customer application: <http://localhost:3000>
-   Admin dashboard: <http://localhost:3001>
-   Backend health: <http://localhost:5000/api/health>

Screenshots captured during validation are stored in `Screenshots/`:

-   `API health 1.png`
-   `Admin dashboard API.png`
-   `Backend connections 1 & 2.png`
-   `Customer frontend API.png`

### 5.5 Remaining Sprint 1 work

-   Finalize and push this README.
-   Create and verify ECR repositories.
-   Set up Jenkins and secure GitHub/AWS credentials.
-   Add and test the Jenkins CI pipeline.
-   Add the final architecture diagram and evidence for cloud/automation
    deliverables.

## 6. AWS ECR setup

Configure AWS CLI credentials securely. Never commit access keys, secret
keys, tokens, or credential files.

``` powershell
aws sts get-caller-identity
aws configure get region
```

Create repositories once, if they do not already exist:

``` powershell
aws ecr create-repository --repository-name cloudforge/frontend --region <region>
aws ecr create-repository --repository-name cloudforge/backend --region <region>
aws ecr create-repository --repository-name cloudforge/admin --region <region>
```

Authenticate Docker to ECR:

``` powershell
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
```

Replace placeholders with the actual AWS account ID and region.

## 7. Kubernetes deployment guidance

A Kubernetes cluster must exist and be accessible before applying
application manifests. For EKS:

``` powershell
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl cluster-info
kubectl get nodes
```

Install cluster prerequisites appropriate to the cluster and cloud
provider, such as Metrics Server, an ingress controller, and the storage
driver/class needed by the persistent-volume design. Follow current
upstream installation instructions for the versions selected.

### 7.1 Deployment options

**Option A --- Raw Kubernetes manifests**

``` powershell
kubectl apply -f kubernetes/k8s-manifests/namespace/
kubectl apply -f kubernetes/k8s-manifests/database/
kubectl apply -f kubernetes/k8s-manifests/backend/
kubectl apply -f kubernetes/k8s-manifests/frontend/
kubectl apply -f kubernetes/k8s-manifests/admin/
kubectl apply -f kubernetes/k8s-manifests/ingress/
```

**Option B --- Helm charts**

``` powershell
helm upgrade --install mongo kubernetes/helm/charts/mongo -n <namespace> --create-namespace
helm upgrade --install backend kubernetes/helm/charts/backend -n <namespace>
helm upgrade --install frontend kubernetes/helm/charts/frontend -n <namespace>
helm upgrade --install admin kubernetes/helm/charts/admin -n <namespace>
```

**Option C --- Argo CD GitOps (optional)**

Install and configure Argo CD using its current official documentation.
Update the repository URL and destination namespace in the application
definitions before applying them.

> Apply only manifests and charts that exist in the repository and have
> been reviewed. Do not put database passwords in manifests or source
> control; use Kubernetes Secrets or an appropriate secret-management
> solution.

### 7.2 Verify Kubernetes resources

Replace `<namespace>` with the configured namespace:

``` powershell
kubectl get pods -n <namespace>
kubectl get deployments -n <namespace>
kubectl get services -n <namespace>
kubectl get statefulsets -n <namespace>
kubectl get hpa -n <namespace>
kubectl get ingress -n <namespace>
kubectl get all -n <namespace>
```

Troubleshooting:

``` powershell
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
```

## 8. Personalization checklist

Before deploying to a shared cluster, review and personalize:

-   Ingress paths for customer and admin applications.
-   Nginx ConfigMap paths and proxy configuration.
-   Docker build arguments, if user-specific arguments are defined.
-   ECR image repository names and tags in deployments and Helm values.
-   Kubernetes namespace references.
-   Argo CD repository URL and destination namespace.
-   AWS region, account ID, and EKS cluster name.

Use consistent namespace and image naming throughout. Never commit
credentials or private keys.

## 9. Security and operations

-   Keep AWS credentials and application secrets out of Git.
-   Use least-privilege IAM permissions for Jenkins and deployment
    identities.
-   Pin and review container image versions.
-   Retain MongoDB data in a persistent volume for local development.
-   Back up important data before changing or removing persistent
    storage.
-   Review AWS costs before provisioning EKS, EC2, load balancers, NAT
    gateways, or persistent storage.
-   Clean up temporary cloud resources when they are no longer required,
    while retaining resources needed for demonstration.

## 10. Final submission checklist

-   [x] Dockerfiles and Docker Compose configuration created.
-   [x] Local containers built and started.
-   [x] Backend, frontend, admin, and reverse-proxy checks passed.
-   [x] Local screenshots captured in `Screenshots/`.
-   [ ] README conflict resolved and changes pushed to GitHub.
-   [ ] ECR repositories created and image push verified.
-   [ ] Jenkins configured and connected to GitHub.
-   [ ] Jenkins pipeline run successfully.
-   [ ] Terraform infrastructure applied and verified.
-   [ ] Ansible playbook executed and verified.
-   [ ] Kubernetes application deployed and verified.
-   [ ] Helm deployment verified.
-   [ ] Argo CD GitOps verified, if required.
-   [ ] Prometheus, Grafana, and alerts verified.
-   [ ] End-to-end pipeline tested and evidence collected.
-   [ ] Cost review and cleanup plan documented.

## 11. Reference documentation

If these files are present in the repository, consult them for
additional detail:

-   [Application architecture](docs/APPLICATION-ARCHITECTURE.md)
-   [Kubernetes concepts](docs/K8S-CONCEPTS.md)
-   [Tools setup guide](docs/TOOLS-SETUP-GUIDE.md)
-   [Troubleshooting guide](docs/TROUBLESHOOTING.md)

## Author

**K Mohan Krishna**
