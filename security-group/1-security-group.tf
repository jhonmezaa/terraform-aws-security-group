# =============================================================================
# Security Group Resources
# =============================================================================

# Security group with fixed name
resource "aws_security_group" "this" {
  count = local.create_sg && !local.use_name_prefix ? 1 : 0

  region = var.region

  name                   = local.sg_name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = local.sg_tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security group with name prefix
resource "aws_security_group" "this_name_prefix" {
  count = local.create_sg && local.use_name_prefix ? 1 : 0

  region = var.region

  name_prefix            = local.sg_name_prefix
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = local.sg_tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# =============================================================================
# VPC Associations (associate the security group with additional VPCs)
# =============================================================================

resource "aws_vpc_security_group_vpc_association" "this" {
  for_each = local.create ? var.vpc_associations : {}

  region = var.region

  security_group_id = local.this_sg_id
  vpc_id            = each.value.vpc_id
}
