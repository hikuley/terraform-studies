# Terraform Studies

A collection of Terraform projects for learning and practicing Infrastructure as Code (IaC) on AWS.

## 📁 Project Structure

```
terraform-studies/
├── ec2-vpc-demo/        # EC2 instance with custom VPC setup
├── kubernetes-demo/     # EKS cluster deployment
└── README.md
```

## Projects

### 🖥️ EC2 + VPC Demo

Provisions a complete VPC environment with an EC2 instance running Nginx.

**Resources created:**
- VPC with DNS support
- Public subnet + Internet Gateway
- Route table and associations
- Security group (SSH, HTTP, HTTPS)
- EC2 instance (Amazon Linux 2) with Nginx bootstrapped via `user_data`

📄 See [ec2-vpc-demo/README.md](ec2-vpc-demo/README.md) for detailed usage instructions.

---

### ☸️ Kubernetes (EKS) Demo

Provisions an Amazon EKS cluster with a managed node group.

**Resources created:**
- VPC with public and private subnets across 2 AZs
- Internet Gateway + NAT Gateway
- IAM roles for EKS cluster and worker nodes
- EKS cluster with configurable Kubernetes version
- Managed node group with auto-scaling

📄 See [kubernetes-demo/README.md](kubernetes-demo/README.md) for detailed usage instructions.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) (v1.0+)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with valid credentials
- An AWS account

## Quick Start

Each project follows the same Terraform workflow:

```bash
# Navigate to a project
cd ec2-vpc-demo   # or kubernetes-demo

# Initialize Terraform
terraform init

# Preview changes
terraform plan -var-file="dev.tfvars"

# Apply changes
terraform apply -var-file="dev.tfvars"

# Destroy resources when done
terraform destroy -var-file="dev.tfvars"
```

> **Note:** Each project uses a `dev.tfvars` file for environment-specific variables. Review and update it before applying.

## Common File Layout

Each project follows a consistent file structure:

| File             | Purpose                                    |
|------------------|--------------------------------------------|
| `main.tf`        | Resource definitions                       |
| `variables.tf`   | Input variable declarations                |
| `outputs.tf`     | Output value definitions                   |
| `locals.tf`      | Local values (tags, naming prefix, etc.)   |
| `dev.tfvars`     | Variable values for the dev environment    |