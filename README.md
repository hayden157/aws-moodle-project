# AWS Moodle Project

This project deploys Moodle on AWS using Terraform, EKS (Kubernetes), and Aurora MySQL.

## Architecture
- **VPC**: Multi-AZ setup with public/private subnets
- **EKS**: Managed Kubernetes cluster with Spot instances
- **Aurora MySQL**: Managed database for Moodle
- **Bitnami Moodle**: Containerized Moodle deployment via Helm

## Features
- Horizontal pod scaling (2 replicas)
- ConfigMap for application settings
- External Load Balancer
- Cost-optimized for AWS Learner Lab

## Deployment
```bash
git clone https://github.com/hayden157/aws-moodle-project.git
cd aws-moodle-project
terraform init
terraform apply
```

## Cleanup
```bash
terraform destroy
```
```

### **2. Now You Can Deploy in AWS Learner Lab**
Your repository URL is: `https://github.com/hayden157/aws-moodle-project.git`

In AWS CloudShell, run:
```bash
git clone https://github.com/hayden157/aws-moodle-project.git
cd aws-moodle-project
terraform init
terraform apply
```
