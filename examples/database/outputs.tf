# =============================================================================
# Outputs
# =============================================================================

output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = module.app_security_group.security_group_id
}

output "app_security_group_name" {
  description = "The name of the application security group"
  value       = module.app_security_group.security_group_name
}

output "db_security_group_id" {
  description = "The ID of the database security group"
  value       = module.database_security_group.security_group_id
}

output "db_security_group_name" {
  description = "The name of the database security group"
  value       = module.database_security_group.security_group_name
}

output "vpc_id" {
  description = "The VPC ID where the security groups were created"
  value       = data.aws_vpc.default.id
}
