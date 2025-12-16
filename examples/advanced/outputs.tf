# =============================================================================
# Outputs
# =============================================================================

# Advanced Security Group Outputs
output "advanced_sg_id" {
  description = "The ID of the advanced security group"
  value       = module.advanced_security_group.security_group_id
}

output "advanced_sg_name" {
  description = "The name of the advanced security group"
  value       = module.advanced_security_group.security_group_name
}

output "advanced_sg_arn" {
  description = "The ARN of the advanced security group"
  value       = module.advanced_security_group.security_group_arn
}

output "advanced_sg_ingress_rules" {
  description = "Summary of ingress rules for the advanced security group"
  value       = module.advanced_security_group.ingress_rules
}

output "advanced_sg_egress_rules" {
  description = "Summary of egress rules for the advanced security group"
  value       = module.advanced_security_group.egress_rules
}

# Minimal Security Group Outputs
output "minimal_sg_id" {
  description = "The ID of the minimal security group"
  value       = module.minimal_security_group.security_group_id
}

output "minimal_sg_name" {
  description = "The name of the minimal security group"
  value       = module.minimal_security_group.security_group_name
}

output "minimal_sg_arn" {
  description = "The ARN of the minimal security group"
  value       = module.minimal_security_group.security_group_arn
}

# VPC Information
output "vpc_id" {
  description = "The VPC ID where the security groups were created"
  value       = data.aws_vpc.default.id
}
