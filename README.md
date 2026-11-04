
# ðŸ›’ CloudForge E-Commerce - Kubernetes Learning Project

CloudForge is a **Kubernetes learning project** built around a full-stack MERN e-commerce application:
- **Customer App** (React frontend)  
- **Admin Dashboard** (React admin panel)  
- **Backend API** (Express + MongoDB)  

This project teaches **Kubernetes** from container basics to production-ready deployments with Dockerfiles, Kubernetes manifests, Helm, GitOps and CICD using Jenkins.

## ðŸŽ¯ Learning Objectives
- Write Dockerfiles for containerising the application
- Master Kubernetes fundamentals through hands-on practice
- Understand and implement HELM Chart for application deployment on kubernetes
- Implement GitOps workflows using ArgoCD
- Implement CICD pipelines using Jenkins
---

## ðŸ“ Project Structure

```
CloudForge/
â”œâ”€â”€ backend/               # Node.js API server
â”œâ”€â”€ frontend/              # React customer app
â”œâ”€â”€ admin/                 # React admin dashboard
â”œâ”€â”€ kubernetes
â”‚   â”œâ”€â”€ k8s-manifests/     # Raw Kubernetes YAML files
â”‚   â”œâ”€â”€ helm/              # Helm charts for package management
â”‚   â”‚   â””â”€â”€ charts/        # Individual charts
â”‚   â”œâ”€â”€ argocd/            # GitOps deployment configs
â”‚   â””â”€â”€ pre-req/           # Cluster prerequisites
â”œâ”€â”€ jenkins/               # Pipeline definitions (CI & CD)       
â”œâ”€â”€ docs/                  # learning resources and guides
â””â”€â”€ scripts/               # Automation and utility scripts
```

---

## ðŸš€ Learning Journey

### Container & Kubernetes Basics
1. **Start Here**: [docs/K8S-CONCEPTS.md](docs/K8S-CONCEPTS.md) - Core concepts explained
2. **Raw Kubernetes Manifests**: `kubernetes/k8s-manifests/`

### Package Management & Automation  
3. **Helm Charts**: `kubernetes/helm/`
4. **CI/CD Pipelines**: `jenkins/`

### GitOps & Production Readiness
5. **ArgoCD GitOps**: `kubernetes/argocd/`


## Getting Started

## ðŸ›  Prerequisites & Setup

#### 1. Setup Tools**: [docs/TOOLS-SETUP-GUIDE.md](docs/TOOLS-SETUP-GUIDE.md)

#### 2. AWS ECR Registry Setup 
```bash
# Setup AWS credentials first
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region (us-east-1), and output format (json)

# Or use environment variables
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=us-east-1

# If above credentials are already set, run below command to verify
aws sts get-caller-identity

# Create ECR repositories either via the aws cli as mentioned below or via console (Has to be done once to create the ECR repo, skip this step when you are rebuilding the docker images):

like:

aws ecr create-repository --repository-name cloudforge/frontend --region <region>
aws ecr create-repository --repository-name cloudforge/backend --region <region>
aws ecr create-repository --repository-name cloudforge/admin --region <region>

# Get login token (run this command everytime as the docker credentials are persisted only on the terminal)
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
```


#### 3. Update Configurations in below mentioned files


## ðŸ”§ Personalization Required

**For Multi-User Kubernetes Clusters**: To avoid conflicts when multiple learners use the same cluster, each user must personalize their deployment with unique identifiers.

**IMPORTANT**: This project contains hardcoded references that you must update with your own values:

3.1. Replace "cloudforge" with your username in these locations:

  **Ingress Paths** (in both Kubernetes manifests and Helm charts):
   - `kubernetes/k8s-manifests/ingress/ingress-cloudforge.yaml`
     - Change `/cloudforge` to `/<your-username>`
     - Change `/cloudforge-admin` to `/<your-username>-admin`
   
   - `kubernetes/helm/charts/frontend/values.yaml`
     - Change `path: /cloudforge` to `path: /<your-username>`
   
   - `kubernetes/helm/charts/admin/values.yaml`
     - Change `path: /cloudforge-admin` to `path: /<your-username>-admin`


  **Nginx ConfigMaps**
   - All references with 'cloudforge' to <your-username> in following files:
   - `kubernetes/k8s-manifests/frontend/cm-nginx.yaml`   
   - `kubernetes/k8s-manifests/admin/cm-nginx.yaml`


  **Helm Chart Nginx Configurations**:
   - All references with 'cloudforge' in the 'nginx.config' section to <your-username> in following files:
   - `kubernetes/helm/charts/frontend/values.yaml` 
   - `kubernetes/helm/charts/admin/values.yaml`

  **Dockerfiles** (Build Arguments):
   - `frontend/Dockerfile`
     - Change `ARG USER_NAME=cloudforge` to `ARG USER_NAME=<your-username>`
   
   - `admin/Dockerfile`
     - Change `ARG USER_NAME=cloudforge` to `ARG USER_NAME=<your-username>`

  **Build Script** (optional):
   - `scripts/build-and-push.sh`
     - Update the example usage comments that reference "cloudforge"

3.2. **ECR Repository Names** - Update to your username:
   - All `kubernetes/k8s-manifests/*/deployment.yaml` files
   - All `kubernetes/helm/charts/*/values.yaml` files
   - All `jenkins\Jenkinsfile.*.*` files
   - Change `shopnow/frontend` to `cloudforge/frontend`
   - Change `shopnow/backend` to `cloudforge/backend`
   - Change `shopnow/admin` to `cloudforge/admin`

3.3. **Update Namespace** on these locations:
  - `kubernetes/k8s-manifests/namespace/namespace.yaml` - Change namespace name
  - All files in `kubernetes/k8s-manifests/*/` - Update namespace references
  - `kubernetes/argocd/apps/*.yaml` - Update destination namespace
  - All kubectl commands in this README - Replace `cloudforge-demo` with your namespace

3.4. **Update ArgoCD Repository URL**:
  - In `kubernetes/argocd/umbrella-application.yaml` and all `kubernetes/argocd/apps/*.yaml` files:
  - Change `repoURL: 'https://github.com/Sandhyashree1812/CloudForge'` 
  - To `repoURL: 'https://github.com/<your-github-username>/<your-repo-name>'`



#### 4. Kubernetes Cluster Access (Make sure to have a running Kubernetes cluster, here is an example to connect with EKS)
```bash
# For EKS cluster
aws eks update-kubeconfig --region <region> --name <your-cluster-name>

# Verify access
kubectl cluster-info
kubectl get nodes
```

Note: All the below mentioned kubectl commands assume that you are working with "cloudforge-demo" namespace, update the namespace as per yours where ever you find "cloudforge-demo".

#### 5. Docker Registry Secret (Only required for private ECR registry)
**Note**: Skip this step if using public Docker Hub images or public ECR repositories.

```bash
# Create registry secret for private ECR image pulls
kubectl create ns cloudforge-demo
kubectl create secret docker-registry ecr-secret --docker-server=<account-id>.dkr.ecr.us-east-1.amazonaws.com --docker-username=AWS --docker-password=$(aws ecr get-login-password --region us-east-1) --namespace=cloudforge-demo
```

#### 6. Install Pre-requisites in the Kubernetes Environment (Has to be done once per Kubernetes Cluster)
```bash
# Install metrics server (required for resource monitoring and HPA)
kubectl apply -f kubernetes/pre-req/metrics-server.yaml

# Install ingress-nginx controller (for external access)
# For EKS, other cloud provider will have different file
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0-beta.0/deploy/static/provider/aws/deploy.yaml

# For local development (minikube/kind/Docker Desktop)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/kind/deploy.yaml

# Verify installations
kubectl get pods -n kube-system
kubectl get pods -n ingress-nginx
kubectl top nodes  # Should work after metrics server is running
kubectl top pods  # Should work after metrics server is running

# To enable Persistent Storage

# First install the EBS CSI driver as an EKS Addon

-> In the EKS Console, open your cluster â†’ go to Add-ons â†’ click Get more add-ons â†’ select Amazon EBS CSI driver â†’ click Next.
-> On the configuration page, Under Pod identity association, choose Create a new IAM role, and the console will auto-attach the AmazonEBSCSIDriverPolicy.
-> Confirm and click Create. The add-on installs, the IAM role is associated with the SA via Pod Identity, and the driver starts running.
-> Verify under Add-ons tab that the EBS CSI driver is active and under Pod identity associations tab you see the SA <-> IAM role mapping.

# Install storage class for persistent volumes
kubectl apply -f kubernetes/pre-req/storageclass-gp3.yaml

# Verify storage class installation
kubectl get storageclass


```


## âš¡ Build and Deploy the micro-services

### 1. Build the docker images and push it to the ECR registry created above

```bash
scripts/build-and-push.sh <account-id>.dkr.ecr.<region>.amazonaws.com/<registry-name> <tag-name-number> <your-username> 

# Example for user 'cloudforge' with tag 'latest' and ECR registry '<AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/cloudforge':
./scripts/build-and-push.sh <AWS_ACCOUNT_ID>.dkr.ecr.<AWS_REGION>.amazonaws.com/cloudforge latest cloudforge


```

### 2. Choose Your Deployment Method

**Option A: Raw Kubernetes Manifests**
```bash
kubectl apply -f kubernetes/k8s-manifests/namespace/
kubectl apply -f kubernetes/k8s-manifests/database/
kubectl apply -f kubernetes/k8s-manifests/backend/
kubectl apply -f kubernetes/k8s-manifests/frontend/
kubectl apply -f kubernetes/k8s-manifests/admin/
kubectl apply -f kubernetes/k8s-manifests/ingress/
kubectl apply -f kubernetes/k8s-manifests/daemonsets-example/
```

**Option B: Helm Charts**

```bash
helm upgrade --install mongo kubernetes/helm/charts/mongo -n cloudforge-demo --create-namespace
helm upgrade --install backend kubernetes/helm/charts/backend -n cloudforge-demo
helm upgrade --install frontend kubernetes/helm/charts/frontend -n cloudforge-demo
helm upgrade --install admin kubernetes/helm/charts/admin -n cloudforge-demo
```

**Option C: ArgoCD GitOps**
```bash
# Install ArgoCD first
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Create target namespace
kubectl create namespace cloudforge-demo

# Deploy applications
kubectl apply -f kubernetes/argocd/umbrella-application.yaml

# Check all ArgoCD application status:
kubectl get applications -n argocd

```

### 3. Create users in MongoDB after the mongodb pods are healthy

```bash

# check the status of the mongo-0 pods 
kubectl get pods -n cloudforge-demo

# if mongo-0 pod is healthy, then run following command to create a user for the backend to connect
# user credentials should be same as mentioned in the backend secrets-db.yaml file
# First exex into the pods
kubectl -n cloudforge-demo exec -it mongo-0 -- mongosh

# Run below commands
use admin;
db.createUser({
  user: 'shopuser',
  pwd: 'CloudForgePass123',
  roles: [
    { role: 'readWrite', db: 'shopnow' },
    { role: 'dbAdmin', db: 'shopnow' }
  ]
});

exit

# Restart backend deployment
kubectl rollout restart deploy backend -n cloudforge-demo
```

### 3. Check the resources deployed

```bash
# Check Pods
kubectl get pods -n cloudforge-demo

# Check Deployment
kubectl get deploy -n cloudforge-demo

# Check Services
kubectl get svc -n cloudforge-demo

# Check daemonsets
kubectl get daemonsets -n cloudforge-demo

# Check statefulsets
kubectl get statefulsets -n cloudforge-demo

# Check HPA
kubectl get hpa -n cloudforge-demo

# Check all of the above at once
kubectl get all -n cloudforge-demo

# Check configmaps
kubectl get cm -n cloudforge-demo

# Check secrets
kubectl get secrets -n cloudforge-demo

# Check ingress
kubectl get ing -n cloudforge-demo

# Sequence to debug in case of any issue with the pods
kubectl get pods -n cloudforge-demo
kubectl describe pod backend-746cc99cd-cqrgf -n cloudforge-demo # Assuming that pod backend-746cc99cd-cqrgf has an error
kubectl logs backend-746cc99cd-cqrgf -n cloudforge-demo --previous # If no details are found in the above command or if details like liveness probe failed are coming

```


---

## ðŸŒ Access the Apps

* **Customer App** â†’ [http://<load-balancer-ip-or-dns>/<your-username>](http://<load-balancer-ip-or-dns>/<your-username>)
* **Admin Dashboard** â†’ [http://<load-balancer-ip-or-dns>/<your-username>-admin](http://<load-balancer-ip-or-dns>/<your-username>-admin)

---

## Additional Notes

**Check the Application Architecture details**: [docs/APPLICATION-ARCHITECTURE.md](docs/APPLICATION-ARCHITECTURE.md)
**Check the Troubleshooting Guide**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
---

## ðŸ‘¨â€ðŸ’» Author

## K Mohan Krishna

--- 

================================= 

Project

1. Project definition


PROJECT TITLE
===============

Cloudforge â€” End-to-End DevOps Project


Problem statement
================= 

Automate the testing, containerization, infrastructure provisioning, configuration, deployment, scaling, monitoring, and recovery of a full-stack e-commerce application using Infrastructure as Code and CI/CD practices.

--------------------------------------------- 

Primary deployment: AWS using Terraform, EC2, ECR, EKS, S3, Jenkins, Ansible, Kubernetes, Prometheus, and Grafana.

-------------------------------------------- 

Extension: Azure using Terraform and AKS if multi-cloud implementation is explicitly required.

======================================= 

2. Detailed end-to-end architecture

=========================================== 

--- text

CloudForge/
â”œâ”€â”€ frontend/                         # React customer app
â”œâ”€â”€ admin/                            # React admin dashboard
â”œâ”€â”€ backend/                          # Express API
â”œâ”€â”€ docker-compose.yml                # Local development
â”œâ”€â”€ terraform/
â”‚   â”œâ”€â”€ bootstrap/                    # S3 backend bootstrap
â”‚   â”œâ”€â”€ modules/
â”‚   â”‚   â”œâ”€â”€ network/                  # VPC and subnets
â”‚   â”‚   â””â”€â”€ eks/                      # EKS infrastructure
â”‚   â””â”€â”€ environments/
â”‚       â”œâ”€â”€ dev/
â”‚       â””â”€â”€ prod/
â”œâ”€â”€ ansible/
â”‚   â”œâ”€â”€ inventory/
â”‚   â”œâ”€â”€ playbooks/
â”‚   â””â”€â”€ roles/
â”œâ”€â”€ jenkins/
â”‚   â”œâ”€â”€ Jenkinsfile.ci
â”‚   â”œâ”€â”€ Jenkinsfile.infrastructure
â”‚   â””â”€â”€ Jenkinsfile.deploy
â”œâ”€â”€ kubernetes/
â”‚   â”œâ”€â”€ k8s-manifests/
â”‚   â”œâ”€â”€ helm/
â”‚   â”‚   â””â”€â”€ charts/
â”‚   â”œâ”€â”€ argocd/
â”‚   â””â”€â”€ pre-req/
â”œâ”€â”€ monitoring/
â”‚   â”œâ”€â”€ prometheus/
â”‚   â”œâ”€â”€ grafana/
â”‚   â””â”€â”€ alerts/
â”œâ”€â”€ scripts/
â”‚   â”œâ”€â”€ build-and-push.sh
â”‚   â””â”€â”€ cleanup.sh
â”œâ”€â”€ tests/
â”œâ”€â”€ docs/
â”œâ”€â”€ .gitignore
â””â”€â”€ README.md

--- 


=================== 

Notes:
This structure preserves the folders described in the CloudForge document and adds dedicated Terraform, Ansible, monitoring and testing organization.

The current repository contains the MERN application and documentation. The Terraform, Ansible, Jenkins, Kubernetes, Helm, ArgoCD, monitoring, and automation directories shown above are planned deliverables and will be created during the upcoming sprints.

==========================  

2. The phases weâ€™ll follow
Phase	What we will accomplish
1	Inspect Cloudforge, run the application, understand its components
2	Dockerize the frontend, admin dashboard, and backend
3	Set up GitHub and Jenkins CI
4	Use Terraform to provision AWS infrastructure
5	Use Ansible for server configuration
6	Push images to ECR and deploy to EKS
7	Add Helm and, if required, Argo CD
8	Set up Prometheus, Grafana, and alerts
9	Test the full pipeline, document results, and analyze cost
10	Add Azure resources if the multi-cloud extension is required

================== 


4. Sprint 1 â€” Architecture design, Dockerization and Jenkins setup

5. Sprint 1
Foundation

Objective: Prepare CloudForge for container-based deployment and establish Jenkins as the automation engine.

Deliverables: Architecture diagram, working Docker images, ECR repositories, Jenkins server, and GitHub integration. 

=================== 

Step 1.1 â€” Inspect the application 

Start in the CloudForge repository.


CloudForge – Sprint 1

Step 1 – Inspect the project


Run:
git status
Get-ChildItem
Test-Path .\docker-compose.yml
docker --version
docker compose version
docker ps


<img width="546" height="258" alt="image" src="https://github.com/user-attachments/assets/0451e1af-140d-4836-8c72-92d84a82e86b" /> 


<img width="590" height="361" alt="image" src="https://github.com/user-attachments/assets/e691c8b7-dd0b-4500-82b3-1518fffde0e4" />


<img width="883" height="206" alt="image" src="https://github.com/user-attachments/assets/72baef3d-144e-4db1-9cde-75bcffbb57f7" />


Step 2 – Check package files before building

1. Check package and lock files

Run:
Get-ChildItem .\frontend,.\admin,.\backend -Name package*


2. Inspect why the admin package file changed

   Run:
   git diff -- .\admin\package.json
   

3. Check the current Dockerfile configurations

   Run:
   Select-String -Path .\frontend\Dockerfile,.\admin\Dockerfile,.\backend\Dockerfile -Pattern "FROM|COPY|RUN|ENV|ARG|EXPOSE|HEALTHCHECK|CMD"

4. Check API routing
Run:
Select-String -Path .\frontend\nginx\default.conf,.\admin\nginx\default.conf -Pattern "location|proxy_pass"

note: all three applications contain their package.json and package-lock.json files, so the Docker build prerequisites are present.

Step 2 – Create Docker Compose configuration

notepad .\docker-compose.yml 

Step 2A – Validate the configuration 

Run:
docker compose config

Step 3 – Build all Docker images

Run:
docker compose build

Step 4 – Start CloudForge

Run:
docker compose up -d

<img width="519" height="112" alt="image" src="https://github.com/user-attachments/assets/46e9e643-e9fc-42c3-84b0-ffb0fb369d91" />


<img width="872" height="187" alt="image" src="https://github.com/user-attachments/assets/9f89d2ce-7098-4b10-8207-3563a38c4036" />

Step 5 — Check container status


<img width="885" height="208" alt="image" src="https://github.com/user-attachments/assets/0a6b0f32-2e4b-4977-b075-983b420f660d" />

Step 6 — Test the backend API 

Run: Invoke-RestMethod http://localhost:5000/api/health

<img width="744" height="118" alt="image" src="https://github.com/user-attachments/assets/bc8624c1-3f1e-4ed5-b7d1-75243419cfe1" />

. Test both web applications

Run: 
Invoke-WebRequest http://localhost:3000/ -UseBasicParsing 

<img width="856" height="435" alt="image" src="https://github.com/user-attachments/assets/0fc33863-6b63-4aa4-9d57-05c60c6425f3" />

Run:
Invoke-WebRequest http://localhost:3001/ -UseBasicParsing 



<img width="882" height="426" alt="image" src="https://github.com/user-attachments/assets/71a04564-a3b3-4ffd-b42a-63bd702fa36b" />


Step 4 — Test the Nginx-to-backend connection

Run:
Invoke-RestMethod http://localhost:3000/api/health
Invoke-RestMethod http://localhost:3001/api/health

<img width="738" height="285" alt="image" src="https://github.com/user-attachments/assets/cc04a091-809c-4301-81fe-295ffc0f6fe9" />

