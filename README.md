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
