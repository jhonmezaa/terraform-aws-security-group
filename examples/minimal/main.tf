# =============================================================================
# Minimal Security Group Example
# =============================================================================
# This is the most minimal example showing a security group with a single
# HTTP ingress rule allowing traffic from anywhere.

module "minimal_sg" {
  source = "../../security-group"

  account_name = var.account_name
  project_name = var.project_name
  vpc_id       = var.vpc_id

  description = "Minimal security group example - HTTP only"

  # Single predefined rule: HTTP from anywhere
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Allow all outbound traffic
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Example = "minimal"
  }
}
