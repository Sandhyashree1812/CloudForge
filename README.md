CloudForge E-Commerce - Kubernetes Learning Project

====================== 

Project

========================== 

1. Project definition
---------------------- 

Project title: CloudForge End-to-End DevOps Project

------------------------------------------------------- 

Problem statement
----------------- 

Automate the testing, containerization, infrastructure provisioning,
configuration, deployment, scaling, monitoring, and recovery of a
full-stack e-commerce application using Infrastructure as Code and CI/CD
practices.

Primary deployment: 
--------------------- 

AWS using Terraform, EC2, ECR, EKS, S3, Jenkins,
Ansible, Kubernetes, Prometheus, and Grafana.

Extension:
---------- 

Azure using Terraform and AKS if multi-cloud
implementation is explicitly required.

------------------------------------------------------ 

2. Detailed end-to-end architecture
   
The end-to-end architecture diagram is a planned project deliverable. It
will be added as the AWS infrastructure and deployment design is
developed.

=============================================== 

1. Overall architecture diagram

   

<img width="1658" height="3160" alt="mermaid-diagram" src="https://github.com/user-attachments/assets/5debde2b-685f-40b1-8350-160d068e27cf" />



Proposed target architecture. Argo CD is optional, and the MongoDB hosting approach will be decided during the deployment design.

====================================================== 

2. How the architecture works

Stage	                   Technology	                Responsibility
1. Source code	            GitHub	               Stores CloudForge source code
2. CI automation	         Jenkins               	Automatically runs the pipeline
3. Build and test         	Jenkins               	Tests and builds application components
4. Containerization      	Docker	               Creates frontend, admin and backend images
5. Image storage	         AWS ECR	               Stores Docker images
6. Infrastructure         	Terraform	            Provisions AWS infrastructure
7. Configuration	         Ansible               	Configures servers and required software
8. Deployment	            Kubernetes / EKS	      Runs application containers
9. Packaging	            Helm            	      Manages Kubernetes deployment configurations
10. Monitoring            	Prometheus	            Collects application and infrastructure metrics
11. Visualization	         Grafana               	Displays monitoring dashboards
12. GitOps	               Argo CD               	Optional automated deployment synchronization





====================================== 

Planned technology and infrastructure
- Cloud platform: AWS
- Infrastructure as Code: Terraform
- Compute and Kubernetes: EC2 and EKS
- Container registry: Amazon ECR
- Object storage: Amazon S3
- CI/CD: Jenkins
- Configuration management: Ansible
- Application deployment: Kubernetes and Helm
- GitOps extension: Argo CD, if required
- Monitoring and visualization: Prometheus and Grafana
Multi-cloud extension: Azure resources using Terraform and AKS will
be considered only if the multi-cloud extension is explicitly required.
Repository organization
The current repository contains the MERN application and documentation.
The Terraform, Ansible, Jenkins, Kubernetes, Helm, Argo CD, monitoring,
and automation directories are planned deliverables and will be created
during the upcoming sprints.

This structure preserves the folders described in the CloudForge project
and adds dedicated Terraform, Ansible, monitoring, and testing
organization as the project progresses. 

======================================================================= 


3. Project phases
------------------- 

  Phase                               What we will accomplish
  1                                   Inspect CloudForge, run the
application, and understand its
components


  2                                   Dockerize the frontend, admin
dashboard, and backend


  3                                   Set up GitHub and Jenkins CI


  4                                   Use Terraform to provision AWS
infrastructure


  5                                   Use Ansible for server
configuration


  6                                   Push images to ECR and deploy to
EKS


  7                                   Add Helm and, if required, Argo CD

  
  8                                   Set up Prometheus, Grafana, and
alerts

  
  9                                   Test the full pipeline, document
results, and analyze cost


10                                  Add Azure resources if the
multi-cloud extension is required

---------------------------------------------------------------------------------------  

4. How we will implement the architecture across sprints
Sprint	            Implementation
Sprint 1	            Docker, Docker Compose, GitHub and Jenkins CI foundation
Sprint 2	            AWS infrastructure provisioning using Terraform
Sprint 3	            Ansible configuration and AWS infrastructure integration
Sprint 4	            ECR image publishing and EKS deployment
Sprint 5	            Kubernetes services, Helm and optional Argo CD
Sprint 6	            Prometheus, Grafana and alerting
Sprint 7	            End-to-end testing, documentation and cost analysis

These are proposed implementation stages; the exact sprint boundaries can be adjusted as we progress. 

=================================================== 

====================================================================================== 


4. Sprint 1 - Architecture design, Dockerization, and Jenkins setup
Foundation

Objective: Prepare CloudForge for container-based deployment and
establish Jenkins as the automation engine.

Planned deliverables: Architecture diagram, working Docker images,
ECR repositories, Jenkins server, and GitHub integration.

Sprint 1 implementation record: The Dockerfiles, Docker Compose
deployment, service health checks, and frontend-to-backend proxy
connections described below were implemented and verified. ECR
repositories, a Jenkins server, and Jenkins pipeline integration remain
planned deliverables; they are not claimed as completed in this
implementation record.

Sprint 1 - Implementation and verification

Step 1.1 - Inspect the application

Start in the CloudForge repository.

CloudForge - Sprint 1, Step 1: Inspect the project

Run these commands in PowerShell:
git status
Get-ChildItem
Test-Path .\docker-compose.yml
docker --version
docker compose version
docker ps

<img width="546" height="258" alt="image" src="https://github.com/user-attachments/assets/0451e1af-140d-4836-8c72-92d84a82e86b" /> 


<img width="590" height="361" alt="image" src="https://github.com/user-attachments/assets/e691c8b7-dd0b-4500-82b3-1518fffde0e4" />


<img width="883" height="206" alt="image" src="https://github.com/user-attachments/assets/72baef3d-144e-4db1-9cde-75bcffbb57f7" />


Step 1.2 - Check package files before building

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
Note: All three applications contain their package.json and
package-lock.json files, so the Docker build prerequisites are
present.

Step 2 - Create Docker Compose configuration
Create or edit the Docker Compose configuration:
notepad .\docker-compose.yml

Step 2A - Validate the configuration
Run:
docker compose config
Step 3 - Build all Docker images
Run:
docker compose build

Step 4 - Start CloudForge
Run:
docker compose up -d

Step 5 - Check container status

Step 6 - Test the backend API
Run:
Invoke-RestMethod http://localhost:5000/api/health

Step 7 - Test both web applications
Test the customer frontend:
Invoke-WebRequest http://localhost:3000/ -UseBasicParsing

Test the admin dashboard:
Invoke-WebRequest http://localhost:3001/ -UseBasicParsing

Step 8 - Test the Nginx-to-backend connection
Run:
Invoke-RestMethod http://localhost:3000/api/health
Invoke-RestMethod http://localhost:3001/api/health

Both Nginx servers successfully forwarded requests to the backend.

  Test                                 Result
  Backend API - port 5000              Passed
Customer frontend - port 3000        HTTP 200
Admin dashboard - port 3001          HTTP 200
Customer frontend to backend proxy   Passed
Admin dashboard to backend proxy     Passed
All four containers                  Healthy

CloudForge is now running as a containerized multi-service application
using Docker Compose.

================================================ 

3. Application architecture
This is the application structure we already implemented using Docker Compose.



<img width="1184" height="1520" alt="mermaid-diagram (1)" src="https://github.com/user-attachments/assets/12b7e8ef-20af-452d-bf15-19a42ce1a858" />



================================================================ 



Step 9 - Open CloudForge in your browser
Open the customer application:

http://localhost:3000

Open the admin dashboard:

http://localhost:3001

Step 10 - Test the products API
Run:
Invoke-RestMethod http://localhost:5000/api/products

What we have verified
1. Customer frontend - working
- CloudForge homepage loads.
- Six products are displayed.
- Product images, names, prices, ratings, and Add to Cart buttons are
  visible.
2. Admin dashboard - working
- CloudForge Admin dashboard loads.
- Order statistics and revenue cards are displayed.
- The orders section loads correctly. It currently shows no orders,
  which is expected if no orders have been placed yet.
3. Backend - working
- /api/products returns product records.
- The backend health endpoint works.
- Both frontend and admin Nginx proxies successfully reach the
  backend.

  ==================================

  
This local architecture is already working:
- Customer frontend: http://localhost:3000
- Admin dashboard: http://localhost:3001
- Backend API: http://localhost:5000
- MongoDB: Docker internal network, port 27017

================================================================ 

Step 3 - Prepare the GitHub update

The Sprint 1 implementation and verification evidence are maintained in
this Git repository. The GitHub update should include the README,
Dockerfiles, Nginx configuration, Docker Compose configuration, and
project verification screenshots.
Next planned work
The next project work will continue with GitHub and Jenkins CI setup,
followed by AWS infrastructure provisioning with Terraform, server
configuration with Ansible, and deployment to EKS. Later sprints will
address Helm, optional Argo CD, monitoring, alerting, end-to-end
pipeline testing, documentation, and cost analysis. The Azure/AKS
extension will be considered only if multi-cloud implementation is
required.












============================================ 

CloudForge E-Commerce - Kubernetes Learning Project

======================= 

Project


===================== 

1. Project definition


PROJECT TITLE
===============

CloudForge End-to-End DevOps Project


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




=================== 

Notes:
This structure preserves the folders described in the CloudForge document and adds dedicated Terraform, Ansible, monitoring and testing organization.

The current repository contains the MERN application and documentation. The Terraform, Ansible, Jenkins, Kubernetes, Helm, ArgoCD, monitoring, and automation directories shown above are planned deliverables and will be created during the upcoming sprints.

==========================  

2. The phases we'll follow
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


4. Sprint 1 Architecture design, Dockerization and Jenkins setup

5. Sprint 1
Foundation

Objective: Prepare CloudForge for container-based deployment and establish Jenkins as the automation engine.

Deliverables: Architecture diagram, working Docker images, ECR repositories, Jenkins server, and GitHub integration. 

=================== 

Step 1.1 Inspect the application 

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


Both Nginx servers successfully forwarded requests to the backend:
Test	Result
Backend API — port 5000	Passed
Customer frontend — port 3000	HTTP 200
Admin dashboard — port 3001	HTTP 200
Customer frontend → backend proxy	Passed
Admin dashboard → backend proxy	Passed
All four containers	Healthy

CloudForge is now running as a containerized multi-service application using Docker Compose.

-------------------------- 

. Open CloudForge in your browser

Open in browser:  Customer application: http://localhost:3000

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b0946b4d-a8eb-415a-ba05-f8c68e8733cd" />


Open in browser: Admin dashboard : http://localhost:3001

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2f1fe73d-aa48-4d4b-93a1-f4cb4ea8168f" /> 


Run:
Invoke-RestMethod http://localhost:5000/api/products



Invoke-RestMethod http://localhost:5000/api/products
<img width="915" height="109" alt="image" src="https://github.com/user-attachments/assets/40d43617-555d-4b82-8ee8-22f15b62a764" /> 


---------------------------------------------- 



What we've verified
1. Customer frontend — working
- CloudForge homepage loads.
- Six products are displayed.
- Product images, names, prices, ratings and Add to Cart buttons are visible.
2. Admin dashboard — working
- CloudForge Admin dashboard loads.
- Order statistics and revenue cards are displayed.
- The orders section loads correctly. It currently shows no orders, which is expected if no orders have been placed yet.
3. Backend — working
- /api/products returns product records.
- The backend health endpoint works.
- Both frontend and admin Nginx proxies successfully reach the backend.

  ==========================================

  Step 3 — Prepare the GitHub update
