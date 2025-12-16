# =============================================================================
# Outputs
# =============================================================================

output "security_group_id" {
  description = "The ID of the created security group"
  value       = module.web_security_group.security_group_id
}

output "security_group_name" {
  description = "The name of the created security group"
  value       = module.web_security_group.security_group_name
}

output "security_group_arn" {
  description = "The ARN of the created security group"
  value       = module.web_security_group.security_group_arn
}

output "vpc_id" {
  description = "The VPC ID where the security group was created"
  value       = data.aws_vpc.default.id
}
