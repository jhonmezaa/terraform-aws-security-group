# =============================================================================
# Ingress Rules - Predefined
# =============================================================================

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = local.create ? { for rule in local.ingress_rules : rule.key => rule } : {}

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = length(var.ingress_cidr_blocks) > 0 ? var.ingress_cidr_blocks[0] : null

  tags = merge(
    {
      Name = "${local.sg_name_tag}-${each.value.rule_name}"
    },
    var.tags
  )
}

# Additional rules for multiple CIDR blocks from predefined rules
resource "aws_vpc_security_group_ingress_rule" "ingress_rules_cidr" {
  for_each = local.create && length(var.ingress_cidr_blocks) > 1 ? {
    for pair in flatten([
      for rule in local.ingress_rules : [
        for idx, cidr in slice(var.ingress_cidr_blocks, 1, length(var.ingress_cidr_blocks)) : {
          key      = "${rule.key}-cidr-${idx}"
          rule     = rule
          cidr     = cidr
          cidr_idx = idx
        }
      ]
    ]) : pair.key => pair
  } : {}

  security_group_id = local.this_sg_id
  description       = each.value.rule.description

  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  ip_protocol = each.value.rule.protocol

  cidr_ipv4 = each.value.cidr

  tags = merge(
    {
      Name = "${local.sg_name_tag}-${each.value.rule.rule_name}-${each.value.cidr_idx}"
    },
    var.tags
  )
}

# =============================================================================
# Ingress Rules - CIDR Blocks
# =============================================================================

resource "aws_vpc_security_group_ingress_rule" "ingress_with_cidr_blocks" {
  for_each = local.create ? { for rule in local.ingress_with_cidr_blocks : rule.key => rule } : {}

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = each.value.cidr_ipv4

  tags = var.tags
}

# =============================================================================
# Ingress Rules - IPv6 CIDR Blocks
# =============================================================================

resource "aws_vpc_security_group_ingress_rule" "ingress_with_ipv6_cidr_blocks" {
  for_each = local.create ? { for rule in local.ingress_with_ipv6_cidr_blocks : rule.key => rule } : {}

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv6 = each.value.cidr_ipv6

  tags = var.tags
}

# =============================================================================
# Ingress Rules - Source Security Group ID
# =============================================================================

resource "aws_vpc_security_group_ingress_rule" "ingress_with_source_security_group_id" {
  for_each = local.create ? { for rule in local.ingress_with_source_security_group_id : rule.key => rule } : {}

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  referenced_security_group_id = each.value.source_security_group_id

  tags = var.tags
}

# =============================================================================
# Ingress Rules - Self
# =============================================================================

resource "aws_vpc_security_group_ingress_rule" "ingress_with_self" {
  for_each = local.create ? { for rule in local.ingress_with_self : rule.key => rule } : {}

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  referenced_security_group_id = local.this_sg_id

  tags = var.tags
}

# =============================================================================
# Ingress Rules - Prefix List IDs
# =============================================================================

resource "aws_vpc_security_group_ingress_rule" "ingress_with_prefix_list_ids" {
  for_each = local.create ? { for rule in local.ingress_with_prefix_list_ids : rule.key => rule } : {}

  security_group_id = local.this_sg_id
  description       = each.value.description

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol

  prefix_list_id = each.value.prefix_list_id

  tags = var.tags
}
