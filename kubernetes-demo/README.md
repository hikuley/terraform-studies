# Kubernetes (EKS) Demo — Terraform

This project provisions an **AWS EKS (Elastic Kubernetes Service)** cluster with a managed node group using Terraform.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  VPC (10.0.0.0/16)                                      │
│                                                         │
│  ┌──────────────────┐  ┌──────────────────┐             │
│  │ Public Subnet 1  │  │ Public Subnet 2  │── IGW ── 🌐│
│  │  10.0.1.0/24     │  │  10.0.2.0/24     │             │
│  └────────┬─────────┘  └──────────────────┘             │
│           │ NAT GW                                      │
│  ┌────────▼─────────┐  ┌──────────────────┐             │
│  │ Private Subnet 1 │  │ Private Subnet 2 │             │
│  │  10.0.3.0/24     │  │  10.0.4.0/24     │             │
│  │  ┌─────┐┌─────┐  │  │  ┌─────┐         │             │
│  │  │Node1││Node2│  │  │  │Node3│         │             │
│  │  └─────┘└─────┘  │  │  └─────┘         │             │
│  └──────────────────┘  └──────────────────┘             │
│                                                         │
│  ┌──────────────────────────────────────────┐           │
│  │          EKS Control Plane               │           │
│  │          (AWS Managed)                   │           │
│  └──────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────┘
```

## Resources Created

| Resource | Description |
|----------|-------------|
| VPC | Custom VPC with DNS support |
| Public Subnets (x2) | Multi-AZ subnets for load balancers |
| Private Subnets (x2) | Multi-AZ subnets for worker nodes |
| Internet Gateway | Internet access for public subnets |
| NAT Gateway | Internet access for private subnets |
| Route Tables | Public (→ IGW) and Private (→ NAT) |
| IAM Roles | Cluster role + Node group role with required policies |
| Security Group | Cluster control plane security group |
| EKS Cluster | Kubernetes control plane (AWS managed) |
| EKS Node Group | Managed worker nodes (auto-scaling) |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) (>= 1.0)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for cluster interaction

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the execution plan

```bash
terraform plan -var-file="dev.tfvars"
```

### 3. Apply the configuration

```bash
terraform apply -var-file="dev.tfvars"
```

> ⏱️ **Note:** EKS cluster creation takes approximately **10-15 minutes**.

### 4. Connect to the cluster with kubectl

```bash
# Update kubeconfig (command is also in terraform output)
aws eks update-kubeconfig --region us-east-1 --name myapp-eks-cluster

# Verify connection
kubectl get nodes
kubectl cluster-info
```

### 5. Destroy all resources

```bash
terraform destroy -var-file="dev.tfvars"
```

> ⚠️ **Warning:** Make sure to destroy resources when not in use — EKS clusters and NAT Gateways incur costs.

## File Structure

```
kubernetes-demo/
├── main.tf          # Provider, VPC, Subnets, EKS, Node Group, IAM
├── variables.tf     # Input variables with defaults & validation
├── locals.tf        # Common tags & name prefix
├── outputs.tf       # Cluster endpoint, kubeconfig command, IDs
├── dev.tfvars       # Dev environment variable values
└── README.md        # This file
```

## Customization

Edit `dev.tfvars` to change environment values, or create new `.tfvars` files for other environments:

```bash
# Example: staging environment
terraform apply -var-file="staging.tfvars"
```
