# E-commerce 

## Overview
This repository contains the infrastructure as code and deployment configurations for an e-commerce platform deployed on Azure Kubernetes Service (AKS). It is designed to provide scalable and resilient infrastructure for handling e-commerce transactions.

## Architecture
The platform uses Kubernetes for orchestration, providing high availability and scalability. The infrastructure is defined using Terraform scripts located in the `terraform/` directory, which setup the AKS cluster and associated networking resources.

## Features
- **Kubernetes Deployment**: Leverages AKS for deploying containerized e-commerce applications.
- **Terraform Infrastructure**: Infrastructure as code using Terraform to provision all required resources on Azure.
- **CI/CD Pipelines**: GitHub Actions for continuous integration and deployment workflows.
- **Secure Secret Management**: Utilizes Azure Key Vault to securely store and access secrets such as database passwords and API keys.


## Prerequisites
- Azure account
- Azure CLI installed
- Kubernetes CLI (kubectl) installed
- Terraform installed

## Setup and Deployment
1. **Clone the repository**:
   ```bash
   git clone https://github.com/Samuelguerrero1184/ecommerce-devops-iac.git
   cd ecommerce-iac
2. ```
   az login
3. ```
   terraform init
4. ```
   terraform plan --var-file .\variables.tfvars
5. ```
   terraform apply --var-file .\variables.tfvars

