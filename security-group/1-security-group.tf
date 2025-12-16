# =============================================================================
# Security Group Resources
# =============================================================================

# Security group with fixed name
resource "aws_security_group" "this" {
  count = local.create_sg && !local.use_name_prefix ? 1 : 0

  name                   = local.sg_name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    {
      Name      = local.sg_name
      ManagedBy = "Terraform"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Security group with name prefix
resource "aws_security_group" "this_name_prefix" {
  count = local.create_sg && local.use_name_prefix ? 1 : 0

  name_prefix            = local.sg_name_prefix
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    {
      Name      = local.sg_name_tag
      ManagedBy = "Terraform"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
