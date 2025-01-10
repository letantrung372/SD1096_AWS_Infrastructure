# Practical DevOps on AWS Cloud-Base

## Prerequisites
- AWS Account
- AWS CLI
- Terraform
- Helm
- kubectl

## Infrastructure Setup

### 0. Create AWS IAM User
```bash
# Create AWS profile
aws configure --profile practical-devops-aws
```

### 1. AWS Resources (Terraform)
```bash
# Move to terraform folder
cd terraform

# Initialize Terraform
terraform init

# Validate Terraform
terraform validate

# Review the plan
terraform plan -var-file=terraform.tfvars -out=terraform.plan

# Apply the configuration
terraform apply terraform.plan
```

Key resources created:
- Amazon Virtual Private Cloud (VPC)
- Amazon Elastic Container Registry (ECR)
- Amazon Elastic Kubernetes Service (EKS)
- EC2 Instances for Jenkins

### 2. CI/CD Pipeline (Jenkins)
#### Setup Steps:
1. Access Jenkins EC2 instance
2. Install required plugins
3. Configure pipeline credentials
3. Configure Jenkins shared library
4. Configure pipeline definitions for each service (frontend/backend)

#### Configure Jenkins Credentials

**1. AWS Credentials**  
These credentials allow Jenkins to push and pull images from the Elastic Container Registry.

**Steps to Configure:**  
Navigate to **Manage Jenkins** > **Credentials** > **System** > **Global credentials**. Add new credentials of type **AWS Credentials**, provide the Access Key ID and Secret Access Key of the IAM user with ECR access.

**2. GitHub Credentials**  
These credentials allow Jenkins to access to GitHub repositories.

**Steps to Configure:**  
Go to **Manage Jenkins** > **Credentials** > **System** > **Global credentials**. Add new credentials of type **GitHub Credentials**, paste the Github userrname and GitHub PAT.

**3. GitHub PAT**  
These credentials allow Jenkins to access to GitHub repositories by command line.

**Steps to Configure:**  
Navigate to **Manage Jenkins** > **Credentials** > **System** > **Global credentials**. Add new credentials of type **Secret Text**, provide the GitHub Personal Access Token.

#### Pipeline Structure:
```
jenkins-shared-library/                 # Shared Library Repository
├── vars/
│   ├── backendServicePipeline.groovy   # Script for backend pipeline
│   └── frontendServicePipeline.groovy  # Script for frontend pipeline
└── src/
    └── org/practicaldevops/
        └── Global.groovy               # Global class contains reusable functions


application-repo/                       # Main Application Repository
└── src/
    ├── backend/
    │   └── Jenkinsfile                 # Backend pipeline using shared library
    └── frontend/
        └── Jenkinsfile                 # Frontend pipeline using shared library

GitOps-repo/                            # GitOps Repository
├── backend/
│   ├── deployment.yaml                 # Backend deployment manifest
├── frontend/
│   ├── deployment.yaml                 # Frontend deployment manifest        
└── database/
        └── mongodb.yaml                # Database deployment manifest
```

#### Pipeline Stages
1. AWS Authentication & ECR Login
2. Build Docker Image
3. Tag & Push to ECR
4. Deploy to EKS

### 3. Monitoring Setup (Prometheus & Grafana)

#### Install Monitoring Stack:
```bash
# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus stack
helm -n monitoring upgrade prometheus-grafana-stack --create-namespace --install prometheus-community/kube-prometheus-stack

# Port forward Prometheus service
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

# Port forward Grafana service
kubectl port-forward -n monitoring svc/prometheus-grafana-stack-grafana 80:80
```

Default Grafana login:
- Username: admin
- Password: prom-operator