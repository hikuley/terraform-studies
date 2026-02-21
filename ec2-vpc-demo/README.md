# EC2 VPC Demo

Deploy an **EC2 instance** running Nginx inside a custom **VPC** on AWS — fully managed with Terraform.

## Architecture

```
Internet
  │
  ▼
Internet Gateway
  │
  ▼
Public Route Table (0.0.0.0/0 → IGW)
  │
  ▼
Public Subnet (10.0.1.0/24)  ─  auto-assigns public IP
  │
  ▼
Security Group (SSH + HTTP + HTTPS)
  │
  ▼
EC2 Instance (Amazon Linux 2 + Nginx)
```

## Resources Created

| Resource              | Description                                      |
|-----------------------|--------------------------------------------------|
| **VPC**               | Custom VPC with DNS support & hostnames enabled  |
| **Internet Gateway**  | Provides internet access to the VPC              |
| **Public Subnet**     | Single public subnet in `us-east-1a`             |
| **Route Table**       | Routes all traffic (`0.0.0.0/0`) through the IGW |
| **Security Group**    | Allows SSH (your IP only), HTTP & HTTPS (public) |
| **EC2 Instance**      | `t2.micro` running Nginx with a welcome page     |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with valid credentials
- An AWS account (free tier eligible)

## Variables

| Variable             | Description                                | Default        |
|----------------------|--------------------------------------------|----------------|
| `region`             | AWS region                                 | `us-east-1`    |
| `env`                | Environment name (used in resource naming) | `dev`           |
| `vpc_cidr`           | CIDR block for the VPC                     | `10.0.0.0/16`  |
| `public_subnet_cidr` | CIDR block for the public subnet           | `10.0.1.0/24`  |
| `instance_type`      | EC2 instance type (`t2.micro` or `t3.micro`) | `t2.micro`   |
| `my_ip`              | Your IP for SSH access (format: `x.x.x.x/32`) | **required** |

## Quick Start

### 1. Clone & Navigate

```bash
git clone <repository-url>
cd ec2-vpc-demo
```

### 2. Configure Variables

Edit `dev.tfvars` and set your IP address for SSH access:

```hcl
region             = "us-east-1"
env                = "dev"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
instance_type      = "t2.micro"
my_ip              = "YOUR_IP_ADDRESS/32"     # ← Replace with your IP
```

> [!TIP]
> Find your public IP by running: `curl -s ifconfig.me`

### 3. Initialize Terraform

```bash
terraform init
```

This downloads the required AWS provider plugin and sets up the backend.

### 4. Preview the Changes

```bash
terraform plan -var-file="dev.tfvars"
```

Review the execution plan to see what resources will be created.

### 5. Apply the Configuration

```bash
terraform apply -var-file="dev.tfvars"
```

Type `yes` when prompted. Terraform will create all the resources and output the instance details.

### 6. Verify

After a successful apply, Terraform will output:

- **`instance_public_ip`** — Public IP of the EC2 instance
- **`web_url`** — Direct HTTP link to the Nginx welcome page

Open the `web_url` in your browser to see:

```
Hello from Terraform EC2 - dev
```

You can also SSH into the instance:

```bash
ssh -i <your-key.pem> ec2-user@<instance_public_ip>
```

> [!NOTE]
> The EC2 instance does not have a key pair attached by default. To enable SSH access, add a `key_name` argument to the `aws_instance` resource in `main.tf`.

## Outputs

| Output                | Description                         |
|-----------------------|-------------------------------------|
| `ami_id`              | AMI ID used for the EC2 instance    |
| `ami_name`            | AMI name used for the EC2 instance  |
| `vpc_id`              | ID of the created VPC               |
| `subnet_id`           | ID of the public subnet             |
| `security_group_id`   | ID of the security group            |
| `instance_id`         | ID of the EC2 instance              |
| `instance_public_ip`  | Public IP address of the instance   |
| `instance_public_dns` | Public DNS hostname of the instance |
| `web_url`             | HTTP URL to access the web server   |

## File Structure

```
ec2-vpc-demo/
├── main.tf          # Core infrastructure (VPC, subnet, SG, EC2)
├── variables.tf     # Input variable definitions with defaults
├── outputs.tf       # Output values (IPs, IDs, URLs)
├── locals.tf        # Local values (naming prefix, common tags)
└── dev.tfvars       # Development environment variable values
```

## Clean Up

To destroy all resources and avoid ongoing charges:

```bash
terraform destroy -var-file="dev.tfvars"
```

Type `yes` to confirm.

> [!CAUTION]
> This will permanently delete all resources created by this configuration, including the EC2 instance and VPC.

## Common Commands Reference

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize the working directory |
| `terraform plan -var-file="dev.tfvars"` | Preview changes |
| `terraform apply -var-file="dev.tfvars"` | Apply changes |
| `terraform destroy -var-file="dev.tfvars"` | Destroy all resources |
| `terraform output` | Show current output values |
| `terraform fmt` | Auto-format `.tf` files |
| `terraform validate` | Validate configuration syntax |
