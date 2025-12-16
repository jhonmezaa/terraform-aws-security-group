# =============================================================================
# Database Security Group Example
# =============================================================================
# This example demonstrates creating a security group for database access
# with PostgreSQL and MySQL rules from specific CIDR blocks.

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
# Application Security Group
# =============================================================================

module "app_security_group" {
  source = "../../security-group"

  account_name = var.account_name
  project_name = var.app_project_name

  description = "Security group for application servers"
  vpc_id      = data.aws_vpc.default.id

  tags = merge(var.tags, {
    Layer = "Application"
  })
}

# =============================================================================
# Database Security Group
# =============================================================================

module "database_security_group" {
  source = "../../security-group"

  account_name = var.account_name
  project_name = var.db_project_name

  description = "Security group for RDS databases"
  vpc_id      = data.aws_vpc.default.id

  # Custom ingress rules for database access
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = var.postgres_cidr_blocks
      description = "PostgreSQL from private subnets"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = var.mysql_cidr_blocks
      description = "MySQL from private subnet"
    }
  ]

  # Allow traffic from application security group
  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.app_security_group.security_group_id
      description              = "PostgreSQL from application servers"
    }
  ]

  # No egress rules needed for database security group
  # (databases typically don't initiate outbound connections)

  tags = merge(var.tags, {
    Layer = "Database"
  })
}
