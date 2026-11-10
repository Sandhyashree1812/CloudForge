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

### Step 3.15 — Fix Docker CLI availability in Jenkins

The first Jenkins pipeline execution failed because the Docker CLI was unavailable inside the Jenkins container.

Error:
`docker: not found`

The Docker socket was already mounted, but Jenkins needed the Docker CLI executable.

Updated `jenkins/Dockerfile` to copy the official Docker CLI executable from the `docker:cli` image:

```dockerfile
FROM docker:cli AS docker-cli

FROM jenkins/jenkins:lts-jdk21

USER root

COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker

USER jenkins
```

Rebuilt and restarted Jenkins while preserving the Jenkins persistent volume.

Verified Docker connectivity from inside Jenkins:
- Docker CLI: 29.7.2
- Docker Desktop Engine: 29.6.1
- Docker client and server communication successful.

### Step 3.16 — Successful Jenkins CI pipeline

Executed `CloudForge-CI` Build #3 successfully.

| Pipeline stage | Result |
|---|---|
| GitHub Checkout | SUCCESS |
| Build Backend Image | SUCCESS |
| Build Frontend Image | SUCCESS |
| Build Admin Image | SUCCESS |

Final pipeline output:

`All CloudForge Docker images built successfully.`

`Finished: SUCCESS`

### Step 3.17 — Verify Docker images

Verified that all three CI images were created locally:

- `cloudforge-backend:ci`
- `cloudforge-frontend:ci`
- `cloudforge-admin:ci`

All three image builds completed successfully.

**Current milestone:** Local Jenkins CI pipeline successfully builds all three CloudForge application Docker images.

**Next phase:** Integrate AWS Elastic Container Registry (ECR) to publish the images. 

--------------------------------- 

We've established:
1. Dockerized MERN application with four healthy services.
2. Jenkins running in Docker.
3. Jenkins CI pipeline successfully building all three application images.
4. GitHub integration and synchronization.
===================================================

Sprint 2 — AWS Infrastructure Provisioning using Terraform for CloudForge.

1. Check Terraform
terraform --version

2. Check AWS CLI
aws --version


3. Check Git
git --version


4. Check your project directory
Get-ChildItem

----------------------- 

The development environment is ready for Sprint 2. Prerequisites verified

Tool	                     Installed version      	Status
Terraform	                  1.16.3	            Ready
AWS CLI	                     2.35.4	            Ready
Git                        	2.53.0	            Ready

====================================== 

Step 2 — Check whether you have AWS account access
--------------------- 

Step 3 — Create an IAM user for Terraform
We'll create a dedicated IAM identity for this learning project.
3.1 Open AWS IAM
1. Sign in to the AWS Management Console.
2. Search for IAM in the top search bar.
3. Open IAM (Identity and Access Management).
4. In the left navigation, select Users.
5. Click Create user.
6. 3.2 Enter the username
   cloudforge-terraform
You do not need to enable AWS Management Console access for this user.
Click Next.


Step 3.1 — Create an IAM group
On your current screen:
1. Keep Add user to group selected.
2. Click Create group on the right.

Step 3.2 — Name the group
Enter:
CloudForge-Terraform-Group
don't attach any policies yet.


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/be9be193-95a0-4ef5-89be-77793f90311e" />


Step 3.2 — Select the new group
On the current page:
1. Scroll down to the User groups (1) section.
2. Find CloudForge-Terraform-Group.
3. Tick the checkbox beside it.
4. Scroll to the bottom and click Next.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/290159f4-a9a1-4c50-a18b-56b1cd74b8bc" /> 

Step 3.3: Check Groups

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/bad7bbad-2cc5-4aff-9368-c81e650dad4a" />

Step 3.4 — Configure permissions
Next, click IAM user groups in the left navigation.
1. Open CloudForge-Terraform-Group.
2. Select its Permissions tab.


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1c586ce1-3f0e-4c62-bdc3-ffb6e18dee17" />


Step 3.5 — Attach an AWS managed policy
For this learning environment, we'll temporarily use the AWS managed PowerUserAccess policy. It provides broad access to AWS services but excludes IAM administration, so it is not a least-privilege production policy. We'll replace it with a narrower custom policy as the project matures.
1. Click Add permissions.
2. Select Attach policies from the dropdown.
3. Search for:
PowerUserAccess
4. Tick the checkbox beside the AWS-managed PowerUserAccess policy.
5. Click Add permissions.

6. We need to let AWS CLI authenticate as cloudforge-terraform.
1. Click IAM users in the left navigation.
2. Click cloudforge-terraform.
3. Open the Security credentials tab.
4. Scroll to Access keys.
5. Click Create access key.
6. Select Command Line Interface (CLI).
7. Acknowledge the recommendation and continue.
8. Create the access key.

   <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7a1038aa-fb72-4098-b4a0-c5892028787f" />

AWS will display an Access key ID and Secret access key. Download the CSV or store them securely. Do not upload the CSV or share either key here.

Step 5 — Configure AWS CLI
Once the access key is created, return to PowerShell:
aws configure

Enter the following when prompted:
Prompt	What to enter
AWS Access Key ID	Your new access key ID
AWS Secret Access Key	Your new secret access key
Default region name	us-east-1
Default output format	json

Step 6 — Verify authentication
Run:
aws sts get-caller-identity

Step 7 — Create the Terraform folder structure

Run: New-Item -ItemType Directory -Force .\terraform 

Then create these files:
Run:
New-Item -ItemType File -Force .\terraform\main.tf
New-Item -ItemType File -Force .\terraform\variables.tf
New-Item -ItemType File -Force .\terraform\outputs.tf
New-Item -ItemType File -Force .\terraform\versions.tf 
New-Item -ItemType File -Force .\terraform\.gitignore 


<img width="271" height="212" alt="image" src="https://github.com/user-attachments/assets/b32f15dd-5c66-42e2-8e02-ff1c51c6ac58" /> 


Step 8 — Verify the files
Run:
Get-ChildItem .\terraform

<img width="670" height="295" alt="image" src="https://github.com/user-attachments/assets/2a9c6e99-fb6f-4d70-aefa-ff10b26aebeb" />


Step 9 — Configure Terraform version and AWS provider


Step 10 — Configure variables
Open:
code .\terraform\variables.tf

Step 11 — Configure the VPC
Open:
code .\terraform\main.tf

Step 12 — Configure outputs
Open:
code .\terraform\outputs.tf

Step 13 — Protect Terraform files
Open:
code .\terraform\.gitignore 

Step 14 — Initialize Terraform

Move into the Terraform directory:
cd .\terraform


Run:
terraform init
Open versions.tf in VS Code:
Run: code .\terraform\versions.tf 

-------------------------------- 

What this does:
- Downloads the AWS provider.
- Initializes the Terraform working directory.
- Prepares Terraform to communicate with AWS.

----------------------- 

Step 15 — Format and validate
After terraform init succeeds, run these commands individually:

1. Format the Terraform files
terraform fmt


2. Validate the configuration
terraform validate

<img width="807" height="487" alt="image" src="https://github.com/user-attachments/assets/2c8f1630-0ec6-421d-a485-11871d39f578" />


4. Check the AWS identity again
aws sts get-caller-identity

Step 18 — Create the execution plan
Run this from C:\Users\sandy\CloudForge\terraform:
terraform plan -out=cloudforge.tfplan


<img width="719" height="290" alt="image" src="https://github.com/user-attachments/assets/f465225e-1a3f-4db7-8875-9da92b04aa02" />



Step 19 — Review of planned AWS infrastructure

<img width="715" height="319" alt="image" src="https://github.com/user-attachments/assets/2ad73461-5b74-4daa-89a4-27a748bf3ae6" />


Step 20 — Apply the Terraform plan
The plan looks correct. If you're happy to create these five resources in your AWS account, run:
terraform apply "cloudforge.tfplan" 

<img width="757" height="366" alt="image" src="https://github.com/user-attachments/assets/aec99323-7858-493b-a73a-c718517f7a9e" />


<img width="830" height="329" alt="image" src="https://github.com/user-attachments/assets/bfbc4d85-cf5b-417e-9f14-736792615271" /> 


======================================================= 

The Terraform successfully created all five AWS resources.

<img width="595" height="345" alt="image" src="https://github.com/user-attachments/assets/e62873e1-2aa9-4ef8-885c-a40596250d04" />

====================================================== 

Step 21 — Verify AWS resources

1. Verify VPC
2. Run: aws ec2 describe-vpcs --filters "Name=tag:Project,Values=CloudForge" --query "Vpcs[*].[VpcId,CidrBlock,State]" --output table

<img width="835" height="131" alt="image" src="https://github.com/user-attachments/assets/fd2246ba-5466-4d88-ae4b-cbac4dd41e2c" />


2. Verify subnet
aws ec2 describe-subnets --subnet-ids subnet-0e511a9a4d6dfbb17 --output table

<img width="823" height="541" alt="image" src="https://github.com/user-attachments/assets/483e6d94-3783-4c33-8af4-326334579d97" />


Verify Internet Gateway
aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0e63f9b6ccdc eea57" --output table

<img width="829" height="124" alt="image" src="https://github.com/user-attachments/assets/b21fc431-44d5-4437-98d9-bff8e3d7d1ab" />


   
======================= 

Step 22 — Preserve the Terraform state

Step 1 — Correct the Internet Gateway command

Run:
aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0e63f9b6ccdceae57" --query "InternetGateways[*].[InternetGatewayId,Attachments[0].State]" --output table


Step 2 — Verify Terraform state
Run:
cd C:\Users\sandy\CloudForge\terraform
terraform state list

<img width="612" height="135" alt="image" src="https://github.com/user-attachments/assets/d2706592-4f98-4189-b793-bf58c3b1bafd" />


Step 23 — Final Internet Gateway verification
We still need to correct the earlier Internet Gateway lookup.

Run this from PowerShell:
aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0e63f9b6ccdceae57" --query "InternetGateways[*].[InternetGatewayId,Attachments[0].State]" --output table 


<img width="825" height="184" alt="image" src="https://github.com/user-attachments/assets/cf1cfc8f-df64-47c6-b6d8-5ffabcc493b7" /> 

Step 24 — Check the Terraform project files
Then run:
Get-ChildItem C:\Users\sandy\CloudForge\terraform -Force

<img width="768" height="342" alt="image" src="https://github.com/user-attachments/assets/9f7942d3-c8a6-45aa-8944-88bda5c8a035" />


Step 25 — One final AWS verification
We still need the Internet Gateway verification result.

Run:
aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0e63f9b6ccdceae57" --query "InternetGateways[*].[InternetGatewayId,Attachments[0].State]" --output table


<img width="817" height="180" alt="image" src="https://github.com/user-attachments/assets/7faf8cc0-5dba-4584-ae80-342afb0c1ba7" />


igw-0ef2be14fb28bf45c    available


Step 26 — Check Git ignore protection
Run:
Get-Content .\.gitignore

Step 26 — Verify state and plan protection
Run these commands:
git check-ignore .\terraform.tfstate
git check-ignore .\cloudforge.tfplan


Step 27 — Check the Internet Gateway
From your current directory, run:
aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=vpc-0e63f9b6ccdceae57" --query "InternetGateways[*].[InternetGatewayId,Attachments[0].State]" --output table

<img width="828" height="435" alt="image" src="https://github.com/user-attachments/assets/b0fb6f3f-61cf-4e63-bb92-60b2aa423e4b" /> 

Step 28 — Check Git status before staging
git status --short
Get-Content .\README.md -Tail 35 

<img width="768" height="182" alt="image" src="https://github.com/user-attachments/assets/5d70709b-12e0-4f33-bf16-abf64f512d90" />


<img width="762" height="554" alt="image" src="https://github.com/user-attachments/assets/a066c58f-8d6a-41ca-832e-c5542ba12b3e" />


Step 29 — Check exactly which Terraform files Git will include
Run:
git status --short --untracked-files=all
