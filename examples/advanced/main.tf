# =============================================================================
# Advanced Security Group Example
# =============================================================================
# This example demonstrates advanced security group configurations including:
# - Multiple rule types (predefined, custom CIDR, IPv6, source SG, self, prefix lists)
# - Name prefix usage
# - Complex ingress and egress rules

provider "aws" {
  region = var.aws_region
}

# =============================================================================
# Data Sources
# =============================================================================

# Get default VPC for the example
data "aws_vpc" "default" {
  default = true
}

# =============================================================================
# Advanced Security Group
# =============================================================================

module "advanced_security_group" {
  source = "../../security-group"

  account_name = var.advanced_account_name
  project_name = var.advanced_project_name
  name         = var.advanced_sg_name

  description     = "Advanced security group with multiple rule types"
  vpc_id          = data.aws_vpc.default.id
  use_name_prefix = var.use_name_prefix

  # Predefined rules
  ingress_rules = [
    "http-80-tcp",
    "https-443-tcp",
    "ssh-tcp"
  ]
  ingress_cidr_blocks = var.vpc_cidr_blocks

  # Custom rules with CIDR blocks
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = var.private_subnet_cidr_blocks
      description = "Custom application port from private subnets"
    },
    {
      from_port   = 9090
      to_port     = 9099
      protocol    = "tcp"
      cidr_blocks = var.monitoring_cidr_blocks
      description = "Monitoring ports from VPC"
    }
  ]

  # IPv6 rules
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      ipv6_cidr_blocks = var.ipv6_cidr_blocks
      description      = "HTTPS from anywhere (IPv6)"
    }
  ]

  # Self-referencing rules (allow traffic within the security group)
  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow all TCP within security group"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      description = "Allow all UDP within security group"
    }
  ]

  # Egress rules
  egress_rules       = ["all-all"]
  egress_cidr_blocks = var.public_cidr_blocks

  # Additional egress to specific CIDR
  egress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = var.database_subnet_cidr_blocks
      description = "MySQL to database subnet"
    }
  ]

  tags = var.advanced_tags
}

# =============================================================================
# Security Group with Minimal Configuration
# =============================================================================

module "minimal_security_group" {
  source = "../../security-group"

  account_name = var.minimal_account_name
  project_name = var.minimal_project_name

  vpc_id = data.aws_vpc.default.id

  # Only allow HTTPS inbound
  ingress_rules       = ["https-443-tcp"]
  ingress_cidr_blocks = var.public_cidr_blocks

  # Allow all outbound
  egress_rules       = ["all-all"]
  egress_cidr_blocks = var.public_cidr_blocks

  tags = var.minimal_tags
}
