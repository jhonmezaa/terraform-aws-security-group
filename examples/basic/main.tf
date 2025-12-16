# =============================================================================
# Basic Security Group Example
# =============================================================================
# This example demonstrates creating a basic security group with predefined
# rules for HTTP and HTTPS traffic.

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
# Security Group Module
# =============================================================================

module "web_security_group" {
  source = "../../security-group"

  account_name = var.account_name
  project_name = var.project_name

  description = "Security group for web application servers"
  vpc_id      = data.aws_vpc.default.id

  # Predefined rules for HTTP and HTTPS
  ingress_rules = ["http-80-tcp", "https-443-tcp"]

  # CIDR blocks to allow traffic from
  ingress_cidr_blocks = var.ingress_cidr_blocks

  # Allow all egress traffic
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags
}
