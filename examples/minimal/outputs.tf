# =============================================================================
# Outputs for Minimal Example
# =============================================================================

output "security_group_id" {
  description = "ID of the created security group"
  value       = module.minimal_sg.security_group_id
}

output "security_group_name" {
  description = "Name of the created security group"
  value       = module.minimal_sg.security_group_name
}

output "security_group_arn" {
  description = "ARN of the created security group"
  value       = module.minimal_sg.security_group_arn
}
