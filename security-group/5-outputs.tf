# =============================================================================
# Security Group Outputs
# =============================================================================

output "security_group_id" {
  description = "The ID of the security group."
  value       = local.this_sg_id
}

output "security_group_arn" {
  description = "The ARN of the security group."
  value = try(
    coalescelist(
      aws_security_group.this[*].arn,
      aws_security_group.this_name_prefix[*].arn,
      [""]
    )[0],
    null
  )
}

output "security_group_name" {
  description = "The name of the security group."
  value = try(
    coalescelist(
      aws_security_group.this[*].name,
      aws_security_group.this_name_prefix[*].name,
      [""]
    )[0],
    null
  )
}

output "security_group_vpc_id" {
  description = "The VPC ID of the security group."
  value = try(
    coalescelist(
      aws_security_group.this[*].vpc_id,
      aws_security_group.this_name_prefix[*].vpc_id,
      [""]
    )[0],
    null
  )
}

output "security_group_owner_id" {
  description = "The owner ID of the security group."
  value = try(
    coalescelist(
      aws_security_group.this[*].owner_id,
      aws_security_group.this_name_prefix[*].owner_id,
      [""]
    )[0],
    null
  )
}

output "security_group_description" {
  description = "The description of the security group."
  value = try(
    coalescelist(
      aws_security_group.this[*].description,
      aws_security_group.this_name_prefix[*].description,
      [""]
    )[0],
    null
  )
}

# =============================================================================
# Security Group Rules Summary
# =============================================================================

output "ingress_rules" {
  description = "Summary of ingress rules created."
  value = {
    predefined               = { for k, v in aws_vpc_security_group_ingress_rule.ingress_rules : k => v.id }
    cidr_blocks              = { for k, v in aws_vpc_security_group_ingress_rule.ingress_with_cidr_blocks : k => v.id }
    ipv6_cidr_blocks         = { for k, v in aws_vpc_security_group_ingress_rule.ingress_with_ipv6_cidr_blocks : k => v.id }
    source_security_group_id = { for k, v in aws_vpc_security_group_ingress_rule.ingress_with_source_security_group_id : k => v.id }
    self                     = { for k, v in aws_vpc_security_group_ingress_rule.ingress_with_self : k => v.id }
    prefix_list_ids          = { for k, v in aws_vpc_security_group_ingress_rule.ingress_with_prefix_list_ids : k => v.id }
  }
}

output "egress_rules" {
  description = "Summary of egress rules created."
  value = {
    predefined               = { for k, v in aws_vpc_security_group_egress_rule.egress_rules : k => v.id }
    cidr_blocks              = { for k, v in aws_vpc_security_group_egress_rule.egress_with_cidr_blocks : k => v.id }
    ipv6_cidr_blocks         = { for k, v in aws_vpc_security_group_egress_rule.egress_with_ipv6_cidr_blocks : k => v.id }
    source_security_group_id = { for k, v in aws_vpc_security_group_egress_rule.egress_with_source_security_group_id : k => v.id }
    self                     = { for k, v in aws_vpc_security_group_egress_rule.egress_with_self : k => v.id }
    prefix_list_ids          = { for k, v in aws_vpc_security_group_egress_rule.egress_with_prefix_list_ids : k => v.id }
  }
}
