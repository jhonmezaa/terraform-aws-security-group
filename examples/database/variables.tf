# =============================================================================
# Variables
# =============================================================================

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "prod"
}

variable "app_project_name" {
  description = "Project name for application security group"
  type        = string
  default     = "api"
}

variable "db_project_name" {
  description = "Project name for database security group"
  type        = string
  default     = "database"
}

variable "postgres_cidr_blocks" {
  description = "CIDR blocks allowed to access PostgreSQL"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "mysql_cidr_blocks" {
  description = "CIDR blocks allowed to access MySQL"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Production"
  }
}
