locals {
  name_prefix = "myapp-${var.env}"

  common_tags = {
    Environment = var.env
    ManagedBy   = "Terraform"
    Project     = "ec2-vpc-demo"
  }
}