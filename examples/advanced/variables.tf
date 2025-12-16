# =============================================================================
# Variables
# =============================================================================

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# Advanced Security Group Variables
variable "advanced_account_name" {
  description = "Account name for advanced security group"
  type        = string
  default     = "prod"
}

variable "advanced_project_name" {
  description = "Project name for advanced security group"
  type        = string
  default     = "microservices"
}

variable "advanced_sg_name" {
  description = "Custom name for advanced security group"
  type        = string
  default     = "advanced-sg"
}

variable "use_name_prefix" {
  description = "Whether to use name prefix for advanced security group"
  type        = bool
  default     = true
}

# Minimal Security Group Variables
variable "minimal_account_name" {
  description = "Account name for minimal security group"
  type        = string
  default     = "dev"
}

variable "minimal_project_name" {
  description = "Project name for minimal security group"
  type        = string
  default     = "test"
}

# Network Configuration
variable "vpc_cidr_blocks" {
  description = "CIDR blocks for VPC access"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "monitoring_cidr_blocks" {
  description = "CIDR blocks for monitoring access"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "database_subnet_cidr_blocks" {
  description = "CIDR blocks for database subnet"
  type        = list(string)
  default     = ["10.0.100.0/24"]
}

variable "ipv6_cidr_blocks" {
  description = "IPv6 CIDR blocks for HTTPS access"
  type        = list(string)
  default     = ["::/0"]
}

variable "public_cidr_blocks" {
  description = "CIDR blocks for public access (minimal SG)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Tags
variable "advanced_tags" {
  description = "Tags for advanced security group"
  type        = map(string)
  default = {
    Environment = "Production"
    Team        = "Platform"
    Managed     = "Terraform"
    Complexity  = "Advanced"
  }
}

variable "minimal_tags" {
  description = "Tags for minimal security group"
  type        = map(string)
  default = {
    Environment = "Development"
  }
}
