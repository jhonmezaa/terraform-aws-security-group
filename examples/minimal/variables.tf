# =============================================================================
# Variables for Minimal Example
# =============================================================================

variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "minimal"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  # Example: "vpc-12345678"
}
