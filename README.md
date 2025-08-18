# IaC-lab-1
Part 2: Hands-On Labs for Terraform, Azure, Kubernetes, and Containers
To build practical experience in Terraform, Azure, Kubernetes, and containers, I’ve curated a series of hands-on labs tailored to your infrastructure focus. These labs will help you create portfolio-worthy projects for your resume and GitHub, aligning with Senior Cloud Engineer requirements. Each lab includes objectives, tools, steps, and expected outcomes, with an emphasis on compute, storage, and automation (not code development).
Lab 1: Deploy a Kubernetes Cluster on Azure AKS Using Terraform
Objective: Deploy a scalable Kubernetes cluster on Azure Kubernetes Service (AKS) using Terraform, simulating an infrastructure setup for a Senior Cloud Engineer role.

Tools: Azure CLI, Terraform, kubectl, GitHub.

Prerequisites:

Azure account (free tier: https://azure.microsoft.com/free/).
Install Azure CLI.
Install Terraform.
Install kubectl.
GitHub account for storing Terraform code.

Steps:

Set Up Azure Environment:

Log in to Azure CLI: az login.
Create a resource group: az group create --name AKS-Lab --location eastus.
Create a service principal for Terraform: az ad sp create-for-rbac --name TerraformSP. Save the output (appId, password, tenant).


Write Terraform Configuration:

Create a directory (aks-lab) and initialize a Terraform project: terraform init.
Create main.tf with the following (replace placeholders with your service principal details):
hclprovider "azurerm" {
  features {}
  client_id     = "<appId>"
  client_secret = "<password>"
  tenant_id     = "<tenant>"
  subscription_id = "<subscription_id>"
}
resource "azurerm_resource_group" "aks" {
  name     = "AKS-Lab"
  location = "East US"
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "akscluster"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

Run terraform plan to validate, then terraform apply to deploy the AKS cluster.


Configure kubectl:

Export the AKS credentials: az aks get-credentials --resource-group AKS-Lab --name aks-cluster.
Verify the cluster: kubectl get nodes.


Deploy a Sample Container:

Create a file nginx.yaml:
yamlapiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

Apply the deployment: kubectl apply -f nginx.yaml.
Verify: kubectl get pods.


Document on GitHub:

Commit main.tf and nginx.yaml to a GitHub repo (e.g., github.com/your-username/aks-lab).
Add a README.md with setup instructions and outcomes (e.g., “Deployed a 2-node AKS cluster with Terraform, hosting an Nginx container”).



Outcome: A functional AKS cluster running a containerized Nginx app, automated via Terraform. Add to resume: “Deployed a Kubernetes cluster on Azure AKS using Terraform, automating infrastructure setup and achieving 99% uptime in a test environment .”

Time Estimate: 2–4 hours.

Resources:

Azure AKS Docs: https://learn.microsoft.com/azure/aks/
Terraform Azure Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

Lab 2: Automate AWS VPC and EC2 Setup with Terraform
Objective: Use Terraform to provision an AWS VPC, subnets, and EC2 instances, simulating infrastructure automation for a Senior Cloud Engineer role.

Tools: AWS CLI, Terraform, GitHub.

Prerequisites:

AWS free tier account.
Install AWS CLI.
Install Terraform.
GitHub account.

Steps:

Set Up AWS Environment:

Configure AWS CLI: aws configure (enter Access Key ID, Secret Access Key, region: us-east-1).
Create a key pair for EC2: aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem.


Write Terraform Configuration:

Create a directory (aws-vpc-lab) and initialize: terraform init.
Create main.tf:
hclprovider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Lab-VPC"
  }
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Public-Subnet"
  }
}
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (update for your region)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "MyKeyPair"
  tags = {
    Name = "Web-Server"
  }
}
output "instance_ip" {
  value = aws_instance.web.public_ip
}

Run terraform plan and terraform apply to provision the VPC and EC2 instance.


Verify Deployment:

SSH into the EC2 instance: ssh -i MyKeyPair.pem ec2-user@<public_ip>.
Confirm the VPC and subnet in the AWS Console (VPC > Subnets).


Document on GitHub:

Commit main.tf to a GitHub repo (e.g., github.com/your-username/aws-vpc).
Add a README.md with setup instructions and outcomes (e.g., “Automated AWS VPC and EC2 provisioning with Terraform, optimizing resource allocation”).



Outcome: A provisioned AWS VPC with an EC2 instance, automated via Terraform. Add to resume: “Built Terraform scripts to automate AWS VPC, EC2, and S3 provisioning, optimizing resource allocation .”

Time Estimate: 2–3 hours.

Resources:

AWS Terraform Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
AWS VPC Docs: https://docs.aws.amazon.com/vpc/

Lab 3: Deploy a Containerized App with Docker and Azure Container Instances
Objective: Build and deploy a containerized application using Docker and Azure Container Instances (ACI), focusing on containerization for infrastructure roles.

Tools: Docker Desktop, Azure CLI, GitHub.

Prerequisites:

Azure free tier account.
Install Docker Desktop.
Install Azure CLI.

Steps:

Create a Docker Image:

Create a directory (aci-lab) and a simple Dockerfile:
dockerfileFROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html

Create index.html:
html<!DOCTYPE html>
<html>
<body>
  <h1>My Azure Container App</h1>
</body>
</html>

Build the Docker image: docker build -t my-nginx-app:latest ..
Test locally: docker run -p 80:80 my-nginx-app.


Push to Azure Container Registry (ACR):

Create an ACR: az acr create --resource-group AKS-Lab --name myacr --sku Basic.
Log in to ACR: az acr login --name myacr.
Tag the image: docker tag my-nginx-app myacr.azurecr.io/my-nginx-app:latest.
Push the image: docker push myacr.azurecr.io/my-nginx-app:latest.


Deploy to Azure Container Instances:

Deploy the container: az container create --resource-group AKS-Lab --name my-nginx-container --image myacr.azurecr.io/my-nginx-app:latest --dns-name-label my-nginx --ports 80.
Get the public URL: az container show --resource-group AKS-Lab --name my-nginx-container --query ipAddress.fqdn.
Access the app in a browser (e.g., http://my-nginx.eastus.azurecontainer.io).


Document on GitHub:

Commit Dockerfile and index.html to a GitHub repo (e.g., github.com/your-username/aci-lab).
Add a README.md with setup instructions and outcomes (e.g., “Deployed a containerized Nginx app on Azure ACI using Docker”).



Outcome: A containerized Nginx app running on Azure ACI, showcasing Docker and Azure skills. Add to resume: “Deployed a containerized Nginx app on Azure Container Instances using Docker, enabling scalable infrastructure .”

Time Estimate: 2–3 hours.

Resources:

Azure Container Instances Docs: https://learn.microsoft.com/azure/container-instances/
Docker Docs: https://docs.docker.com/

Learning Plan

Week 1: Complete Lab 1 (Azure AKS with Terraform). Focus on understanding Terraform syntax and AKS configuration.
Week 2: Complete Lab 2 (AWS VPC with Terraform). Practice automating cloud infrastructure and compare AWS vs. Azure.
Week 3: Complete Lab 3 (Docker and Azure ACI). Learn containerization basics and integration with Azure.
Week 4: Combine skills by extending Lab 1 to deploy a containerized app on AKS (e.g., the Nginx app from Lab 3). Document all projects on GitHub with detailed READMEs.

Additional Resources

Free Courses:

Microsoft Learn: “Introduction to Azure Kubernetes Service”.
HashiCorp Learn: “Getting Started with Terraform on Azure”.
KodeKloud: “Kubernetes for Beginners”.


Certifications to Consider:

Certified Kubernetes Administrator (CKA): Validates Kubernetes expertise (focus on infrastructure tasks).
Azure Solutions Architect Expert (AZ-305): Builds on your AZ-104 for advanced Azure architecture.


Community: Join the Kubernetes Slack or HashiCorp Community for support.
