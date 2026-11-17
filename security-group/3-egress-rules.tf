# =============================================================================
# Egress Rules - Predefined
# =============================================================================

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  # Created for the first IPv4 CIDR. Skipped when only IPv6 CIDRs are provided;
  # kept (and rejected by the precondition) when no CIDR at all is provided.
  for_each = local.create && (length(var.egress_cidr_blocks) > 0 || length(var.egress_ipv6_cidr_blocks) == 0) ? { for rule in local.egress_rules : rule.key => rule } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = length(var.egress_cidr_blocks) > 0 ? var.egress_cidr_blocks[0] : null

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-${each.value.rule_name}"
    ManagedBy = "Terraform"
  })

  lifecycle {
    precondition {
      condition     = length(var.egress_cidr_blocks) > 0 || length(var.egress_ipv6_cidr_blocks) > 0
      error_message = "egress_rules requiere al menos un CIDR en egress_cidr_blocks o egress_ipv6_cidr_blocks."
    }
  }
}

# Additional rules for multiple CIDR blocks from predefined rules
resource "aws_vpc_security_group_egress_rule" "egress_rules_cidr" {
  for_each = local.create && length(var.egress_cidr_blocks) > 1 ? {
    for pair in flatten([
      for rule in local.egress_rules : [
        for idx, cidr in slice(var.egress_cidr_blocks, 1, length(var.egress_cidr_blocks)) : {
          key      = "${rule.key}-cidr-${idx}"
          rule     = rule
          cidr     = cidr
          cidr_idx = idx
        }
      ]
    ]) : pair.key => pair
  } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.rule.description

  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  ip_protocol = each.value.rule.protocol

  cidr_ipv4 = each.value.cidr

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-${each.value.rule.rule_name}-${each.value.cidr_idx}"
    ManagedBy = "Terraform"
  })
}

# Predefined rules applied to every IPv6 CIDR block
resource "aws_vpc_security_group_egress_rule" "egress_rules_ipv6" {
  for_each = local.create ? {
    for pair in flatten([
      for rule in local.egress_rules : [
        for idx, cidr in var.egress_ipv6_cidr_blocks : {
          key      = "${rule.key}-ipv6-${idx}"
          rule     = rule
          cidr     = cidr
          cidr_idx = idx
        }
      ]
    ]) : pair.key => pair
  } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.rule.description

  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  ip_protocol = each.value.rule.protocol

  cidr_ipv6 = each.value.cidr

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-${each.value.rule.rule_name}-ipv6-${each.value.cidr_idx}"
    ManagedBy = "Terraform"
  })
}

# =============================================================================
# Egress Rules - CIDR Blocks
# =============================================================================

resource "aws_vpc_security_group_egress_rule" "egress_with_cidr_blocks" {
  for_each = local.create ? { for rule in local.egress_with_cidr_blocks : rule.key => rule } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = each.value.cidr_ipv4

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-egress-${each.key}"
    ManagedBy = "Terraform"
  })
}

# =============================================================================
# Egress Rules - IPv6 CIDR Blocks
# =============================================================================

resource "aws_vpc_security_group_egress_rule" "egress_with_ipv6_cidr_blocks" {
  for_each = local.create ? { for rule in local.egress_with_ipv6_cidr_blocks : rule.key => rule } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv6 = each.value.cidr_ipv6

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-egress-${each.key}"
    ManagedBy = "Terraform"
  })
}

# =============================================================================
# Egress Rules - Source Security Group ID
# =============================================================================

resource "aws_vpc_security_group_egress_rule" "egress_with_source_security_group_id" {
  for_each = local.create ? { for rule in local.egress_with_source_security_group_id : rule.key => rule } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  referenced_security_group_id = each.value.source_security_group_id

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-egress-${each.key}"
    ManagedBy = "Terraform"
  })
}

# =============================================================================
# Egress Rules - Self
# =============================================================================

resource "aws_vpc_security_group_egress_rule" "egress_with_self" {
  for_each = local.create ? { for rule in local.egress_with_self : rule.key => rule } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  referenced_security_group_id = local.this_sg_id

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-egress-${each.key}"
    ManagedBy = "Terraform"
  })
}

# =============================================================================
# Egress Rules - Prefix List IDs
# =============================================================================

resource "aws_vpc_security_group_egress_rule" "egress_with_prefix_list_ids" {
  for_each = local.create ? { for rule in local.egress_with_prefix_list_ids : rule.key => rule } : {}

  region = var.region

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  prefix_list_id = each.value.prefix_list_id

  tags = merge(local.rule_tags, {
    Name      = "${local.sg_name_tag}-egress-${each.key}"
    ManagedBy = "Terraform"
  })
}
