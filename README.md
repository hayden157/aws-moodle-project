# 📘 AWS Moodle Project - Full Terraform Deployment

This project deploys a **fully functional Moodle LMS** on AWS using the following stack:
- Terraform for Infrastructure-as-Code (IaC)
- Amazon EKS for hosting Moodle (via Kubernetes)
- Bitnami Moodle container deployed via Helm
- Amazon RDS (MySQL) as the Moodle backend database
- AWS Load Balancer for public access

> 🧾 Based on: `ITP4122_EA.docx` project report

---

## 🧱 Architecture Overview

```
┌────────────────────────┐
│     Amazon Route53     │ (Optional)
└────────────┬───────────┘
             ↓
      ┌─────────────┐     ┌─────────────┐
      │  ALB (80/443)│ <--→│  Public Subnets │ (AZ1 + AZ2)
      └──────┬────────┘     └─────────────┘
             ↓
        ┌─────────────┐
        │   EKS Nodes │ ← Helm → Moodle (Bitnami)
        └──────┬──────┘
               ↓
        ┌─────────────┐
        │   RDS MySQL │ (Multi-AZ, private subnets)
        └─────────────┘
```

---

## 📁 Project Structure

```
aws-moodle-project/
├── main.tf                  # Root Terraform file (calls modules)
├── variables.tf             # AWS region and other vars
├── outputs.tf               # Exports ALB hostname
├── providers.tf             # AWS + Kubernetes providers
├── moodle-values.yaml       # Helm values for Moodle chart
└── modules/                 # Modular design
    ├── vpc/                 # VPC, subnets, NAT, routes
    ├── eks/                 # EKS cluster + node group
    ├── rds/                 # RDS MySQL
    └── helm_moodle/         # Helm chart deployment
```

---

## 🚀 Step-by-Step Deployment Guide

### ✅ Prerequisites

| Tool        | Version         |
|-------------|-----------------|
| Terraform   | >= 1.3          |
| AWS CLI     | Configured user |
| Helm        | >= 3.0          |
| kubectl     | Configured w/ IAM user |

---

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/use1essx/aws-moodle-project -b update_4
cd aws-moodle-project
```

### 2️⃣ Initialize Terraform
```bash
terraform init
```

### 3️⃣ Review and Customize Variables
Edit `variables.tf` (if needed) to change region or add `backend`.

Edit `moodle-values.yaml` to change Moodle password or DB settings.

### 4️⃣ Deploy Infrastructure
```bash
terraform apply
```
Answer `yes` when prompted.

⏳ Wait 5–10 minutes while:
- VPC, Subnets, NATs, ALB are created
- EKS and Node Group are provisioned
- RDS MySQL (Multi-AZ) is deployed
- Helm auto-deploys Bitnami Moodle container

---

### 5️⃣ Access Moodle Site
```bash
terraform output moodle_url
```
Open the resulting URL in your browser (e.g. `http://moodle-12345.elb.amazonaws.com`).

Login using:
- Username: `admin`
- Password: as set in `moodle-values.yaml`

---

## 🔒 Security & Configuration Notes

- ✅ RDS is private, only accessible from EKS nodes
- ✅ Secrets are injected securely from Terraform
- ✅ ALB is public; can be secured with WAF or HTTPS (ACM + Route53)
- 🛡️ Moodle data stored on gp3 EBS volumes

---

## 🛠️ Optional Improvements

- [ ] Route53 + ACM certificate for HTTPS support
- [ ] S3 bucket for Moodle media + file backups
- [ ] CloudWatch monitoring + auto scaling
- [ ] CI/CD via GitHub Actions or CodePipeline

---

## 👨‍💻 Maintainer

**Author**: [use1essx](https://github.com/use1essx)  
**Branch**: [`update_4`](https://github.com/use1essx/aws-moodle-project/tree/update_4)

---

## 📄 License

MIT License
