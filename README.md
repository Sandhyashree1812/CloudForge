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

======================= 

Notes:
This structure preserves the folders described in the CloudForge document and adds dedicated Terraform, Ansible, monitoring and testing organization.

The current repository contains the MERN application and documentation. The Terraform, Ansible, Jenkins, Kubernetes, Helm, ArgoCD, monitoring, and automation directories shown above are planned deliverables and will be created during the upcoming sprints. 



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


======================================= 

Objective:
---------- 
Prepare CloudForge for container-based deployment and
establish Jenkins as the automation engine.

Planned deliverables: Architecture diagram, working Docker images,
ECR repositories, Jenkins server, and GitHub integration.


------------------------------------------------------------------ 

Sprint 1 
----------------- 

implementation record: The Dockerfiles, Docker Compose
deployment, service health checks, and frontend-to-backend proxy
connections described below were implemented and verified. ECR
repositories, a Jenkins server, and Jenkins pipeline integration remain
planned deliverables; they are not claimed as completed in this
implementation record.

------------------------------------------------------------------------ 

Sprint 1 - Implementation and verification
------------------------------------------

Step 1.1 - Inspect the application
------------------------------------ 


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
Get-ChildItem .\frontend,.\admin,.\backend -Name package

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


<img width="519" height="112" alt="image" src="https://github.com/user-attachments/assets/46e9e643-e9fc-42c3-84b0-ffb0fb369d91" />



<img width="872" height="187" alt="image" src="https://github.com/user-attachments/assets/9f89d2ce-7098-4b10-8207-3563a38c4036" /> 



Step 5 - Check container status  


<img width="885" height="208" alt="image" src="https://github.com/user-attachments/assets/0a6b0f32-2e4b-4977-b075-983b420f660d" /> 


Step 6 - Test the backend API
Run:
Invoke-RestMethod http://localhost:5000/api/health

<img width="744" height="118" alt="image" src="https://github.com/user-attachments/assets/bc8624c1-3f1e-4ed5-b7d1-75243419cfe1" />

Step 7 - Test both web applications
Test the customer frontend:
Run: Invoke-WebRequest http://localhost:3000/ -UseBasicParsing 

<img width="856" height="435" alt="image" src="https://github.com/user-attachments/assets/0fc33863-6b63-4aa4-9d57-05c60c6425f3" />

Test the admin dashboard:

Run:
Invoke-WebRequest http://localhost:3001/ -UseBasicParsing 


<img width="882" height="426" alt="image" src="https://github.com/user-attachments/assets/71a04564-a3b3-4ffd-b42a-63bd702fa36b" /> 



Step 8 - Test the Nginx-to-backend connection
Run:
Invoke-RestMethod http://localhost:3000/api/health
Invoke-RestMethod http://localhost:3001/api/health 


<img width="738" height="285" alt="image" src="https://github.com/user-attachments/assets/cc04a091-809c-4301-81fe-295ffc0f6fe9" /> 

---------------------------------------------- 


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

Step 9 - Open CloudForge in your browser
Open in browser:  Customer application: http://localhost:3000


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b0946b4d-a8eb-415a-ba05-f8c68e8733cd" />


-------------------------------------- 

Open in browser: Admin dashboard : http://localhost:3001

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2f1fe73d-aa48-4d4b-93a1-f4cb4ea8168f" /> 

-------------------------------------------- 

Step 10 - Test the products API

Run:
Invoke-RestMethod http://localhost:5000/api/products


<img width="915" height="109" alt="image" src="https://github.com/user-attachments/assets/40d43617-555d-4b82-8ee8-22f15b62a764" /> 

========================================== 


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

3. Application architecture
This is the application structure we implemented using Docker Compose.



<img width="1184" height="1520" alt="mermaid-diagram (1)" src="https://github.com/user-attachments/assets/12b7e8ef-20af-452d-bf15-19a42ce1a858" />


================================================================ 
  
This local architecture is already working:
- Customer frontend: http://localhost:3000
- Admin dashboard: http://localhost:3001
- Backend API: http://localhost:5000
- MongoDB: Docker internal network, port 27017

================================================================ 

Step 3 - Prepare the GitHub update 

Step 3.1 — Check the current GitHub and project state  

Run:
git status
git log -1 --oneline
git remote -v

Step 3.2 — Inspect the application build scripts
Run:
Get-Content .\backend\package.json
Get-Content .\frontend\package.json
Get-Content .\admin\package.json
docker ps -a --filter "name=jenkins"

Step 3.3 — Check Docker access for Jenkins
Run:
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock docker:cli docker version 

<img width="874" height="474" alt="image" src="https://github.com/user-attachments/assets/ecfafaa7-c273-4446-b6a4-a40d6378c688" />


Step 3.4 — Verify package lock files
Run:
Test-Path .\backend\package-lock.json
Test-Path .\frontend\package-lock.json
Test-Path .\admin\package-lock.json   

<img width="702" height="127" alt="image" src="https://github.com/user-attachments/assets/5feb8b12-89d6-4b1b-8523-211de4035e2d" />


Step 3.5 — Create the Jenkins pipeline

First, check your repository structure
Run:
Get-ChildItem -Force 

Step 3.5 — Two remaining checks
1. Inspect Docker Compose:
Get-Content .\docker-compose.yml
2. Check Git ignore configuration
Test-Path .\.gitignore

Step 3.6 — Create Jenkins configuration files

1. Create the Jenkins folder
Run:
New-Item -ItemType Directory -Force .\jenkins

--------------------------------------------
2. Create the Jenkins Dockerfile
Run:
@'
FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends docker.io \
    && rm -rf /var/lib/apt/lists/*

USER jenkins
'@ | Set-Content .\jenkins\Dockerfile 

-------------------------------------------------------- 

3. Create the Jenkins Compose file
Run:
@'
services:
  jenkins:
    build:
      context: .
      dockerfile: jenkins/Dockerfile
    container_name: cloudforge-jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    group_add:
      - "0"
    restart: unless-stopped

volumes:
  jenkins_home:
'@ | Set-Content .\jenkins\docker-compose.yml
---------------------------------------------------- 

Notes:
group_add: "0" allows the Jenkins process to access a Docker socket owned by the root group on typical Docker Desktop Linux containers. We'll verify this rather than assume it works.

Security note: Docker socket access gives Jenkins powerful control over your Docker environment. This configuration is for your local learning setup, not a hardened production Jenkins server.

--------------------------------------------------------- 

4. Create the Jenkinsfile
Run:
@'
pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend Image') {
            steps {
                sh 'docker build -t cloudforge-backend:ci ./backend'
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh 'docker build -t cloudforge-frontend:ci ./frontend'
            }
        }

        stage('Build Admin Image') {
            steps {
                sh 'docker build -t cloudforge-admin:ci ./admin'
            }
        }
    }

    post {
        success {
            echo 'All CloudForge Docker images built successfully.'
        }
        failure {
            echo 'CloudForge CI pipeline failed. Review the stage logs.'
        }
    }
}
'@ | Set-Content .\Jenkinsfile

------------------------------------------- 

Notes:
The Docker builds also execute the application dependency installation and React production builds defined in your Dockerfiles.

----------------------------------- 

5. Create a .gitignore
Run:
@'
# Node dependencies
node_modules/

# Environment and secrets
.env
.env.*
!.env.example

# Logs
*.log
npm-debug.log*

# Build outputs
build/
coverage/

# Jenkins local data
jenkins_home/

# Operating system and editor files
.DS_Store
Thumbs.db
.vscode/
'@ | Set-Content .\.gitignore 

---------------------------------------------  

6. Verify the new files
Run:
Get-ChildItem .\jenkins
Get-Content .\Jenkinsfile
Get-Content .\.gitignore
git status

---------------------- 

File description:

File	                           Purpose
jenkins/Dockerfile	         Builds the Jenkins environment
jenkins/docker-compose.yml	   Runs Jenkins separately from CloudForge
Jenkinsfile	                  Defines the CI pipeline
.gitignore	                  Excludes local dependencies, secrets and generated files

-------------------------------------------------------------------------------------------- 

Step 3.7 — Validate Jenkins configuration

Run:
docker compose -f .\jenkins\docker-compose.yml config

Then check whether port 8080 is already occupied:
Run:
Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue

Step 3.7A — Correct the Dockerfile path

Because the build context is already the jenkins folder, Docker will look for jenkins/Dockerfile inside that folder, which is incorrect. We should correct this before building.

Run this PowerShell command:
(Get-Content .\jenkins\docker-compose.yml) -replace 'dockerfile: jenkins/Dockerfile', 'dockerfile: Dockerfile' | Set-Content .\jenkins\docker-compose.yml

Run:
docker compose -f .\jenkins\docker-compose.yml config 

Step 3.7B — Check port 8080
Run:
Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue

Step 3.7C — Change the Jenkins port
Run:
(Get-Content .\jenkins\docker-compose.yml) -replace '"8080:8080"', '"8081:8080"' | Set-Content .\jenkins\docker-compose.yml

Validate the configuration:
Run:
docker compose -f .\jenkins\docker-compose.yml config

Step 3.8 — Build the Jenkins image
Once the configuration is correct, run:
docker compose -f .\jenkins\docker-compose.yml build 

Step 3.9 — Start Jenkins
Run:
docker compose -f .\jenkins\docker-compose.yml up -d

Then check its status:
docker ps --filter "name=cloudforge-jenkins" 

Step 3.10 — Check Jenkins startup logs
Run:
docker logs cloudforge-jenkins --tail 50 

--------------------------- 

logs confirm:
- Jenkins version: 2.580.2
- Java runtime: 21.0.13
- Container: cloudforge-jenkins
- Jenkins URL: http://localhost:8081
- Persistent Jenkins storage: jenkins_jenkins_home

- ---------------------------


1. Open Jenkins
Open this URL in your browser:

http://localhost:8081 

2. Enter the initial administrator password
Your startup log displayed the initial password. For security, retrieve it directly from the container rather than copying it from the chat:

Copy the result and paste it into the Jenkins browser page. 

Run:
docker exec cloudforge-jenkins cat /var/jenkins_home/secrets/initialAdminPassword




<img width="1258" height="645" alt="image" src="https://github.com/user-attachments/assets/9b0bf488-ee9a-4eeb-94b9-a6db86734d4b" /> 

------------------------- 

3. Install plugins
Select:

Install suggested plugins

Wait until the installation finishes. 

<img width="580" height="348" alt="image" src="https://github.com/user-attachments/assets/4de28811-2a8b-4678-a791-8a499718f0fe" />

<img width="479" height="546" alt="image" src="https://github.com/user-attachments/assets/c436e928-e2d7-43c0-9300-a2be63b599f1" />


4. Create your administrator account
Enter:
- Username: Choose your preferred username.
- Password: Create a strong password.
- Full name: Your preferred name.
- Email: Your email address.
Save and continue.

5. Confirm Jenkins is accessible
You should eventually see the Jenkins dashboard.

<img width="711" height="480" alt="image" src="https://github.com/user-attachments/assets/574f5cd2-15e6-421a-af3a-5267649819a6" /> 


<img width="1273" height="571" alt="image" src="https://github.com/user-attachments/assets/ca194b57-88df-4b4d-a9da-83906660a615" />

--------------------------- 

Next, we'll create a Pipeline job connected to the GitHub repository.
Step 3.11 — Create the CloudForge CI job

1. Create a new Jenkins job
On the dashboard:
1. Click New Item on the left.
2. Enter this name: CloudForge-CI
3. Select Pipeline.
   Click OK.

2. Configure the pipeline
On the configuration page, scroll down to the Pipeline section.

For now, select:
- Definition: Pipeline script from SCM
- SCM: Git
- Field	                        Value
Repository URL	      https://github.com/Sandhyashree1812/CloudForge.git
Branch Specifier	               */main
Script Path	                  Jenkinsfile

Leave Credentials empty if the GitHub repository is public.
3. Save



<img width="1246" height="549" alt="image" src="https://github.com/user-attachments/assets/37de129a-17e5-448d-b9ff-2a20c539b90f" /> 



<img width="1270" height="614" alt="image" src="https://github.com/user-attachments/assets/fceb4579-10ca-48d4-8ea7-c1f03711984e" />


Then:
1. Open the CloudForge-CI job.
2. Click Build Now.
3. Wait for Build History to show a build.
4. Open the build number and select Console Output.

Step 3.12 — Check whether Jenkinsfile is on GitHub

Step 3.13 — Commit Jenkins files to GitHub

Step 3.14 — Fetch the latest GitHub changes
Run:
git fetch origin

Step 3.14A — Inspect the GitHub README update
