# =============================================================================
# General Configuration Variables
# =============================================================================

variable "create" {
  description = "Whether to create security group and rules."
  type        = bool
  default     = true
}

variable "create_sg" {
  description = "Whether to create security group. If false, an existing security group ID must be provided."
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "ID of existing security group to use when create_sg = false."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created."
  type        = string
  default     = null
}

# =============================================================================
# Naming Variables
# =============================================================================

variable "account_name" {
  description = "Account name for resource naming."
  type        = string

  validation {
    condition     = length(var.account_name) > 0 && length(var.account_name) <= 32
    error_message = "account_name debe tener entre 1 y 32 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.account_name))
    error_message = "account_name solo puede contener letras minúsculas, números y guiones."
  }
}

variable "project_name" {
  description = "Project name for resource naming."
  type        = string

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "project_name debe tener entre 1 y 32 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name solo puede contener letras minúsculas, números y guiones."
  }
}

variable "name" {
  description = "Name of the security group. If not provided, a name will be generated using account_name and project_name."
  type        = string
  default     = null
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix instead of name for the security group."
  type        = bool
  default     = false
}

variable "region_prefix" {
  description = "Region prefix for naming. If not provided, will be derived from current region."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the security group."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Additional tags to apply to the security group."
  type        = map(string)
  default     = {}
}

# =============================================================================
# Ingress Rules - Predefined
# =============================================================================

variable "ingress_rules" {
  description = <<-EOT
    List of predefined ingress rule names to create. Available rules:
    - http-80-tcp, https-443-tcp
    - ssh-tcp
    - postgresql-tcp, mysql-tcp
    - aurora-postgresql-tcp, aurora-mysql-tcp
    - redis-tcp, mongodb-tcp
    - elasticsearch-tcp, kafka-tcp, rabbitmq-tcp
    - dns-udp, dns-tcp, nfs-tcp
    - all-all, all-icmp
  EOT
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      contains([
        "http-80-tcp", "https-443-tcp", "ssh-tcp",
        "postgresql-tcp", "mysql-tcp",
        "aurora-postgresql-tcp", "aurora-mysql-tcp",
        "redis-tcp", "mongodb-tcp",
        "elasticsearch-tcp", "kafka-tcp", "rabbitmq-tcp",
        "dns-udp", "dns-tcp", "nfs-tcp",
        "all-all", "all-icmp"
      ], rule)
    ])
    error_message = "Una o más reglas de ingress no son válidas. Consulta la descripción de la variable para ver las reglas disponibles."
  }
}

# =============================================================================
# Ingress Rules - CIDR Blocks
# =============================================================================

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules with CIDR blocks."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string, "Ingress Rule")
  }))
  default = []
}

variable "ingress_cidr_blocks" {
  description = "List of CIDR blocks to apply to all predefined ingress rules."
  type        = list(string)
  default     = []
}

# =============================================================================
# Ingress Rules - IPv6 CIDR Blocks
# =============================================================================

variable "ingress_with_ipv6_cidr_blocks" {
  description = "List of ingress rules with IPv6 CIDR blocks."
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    ipv6_cidr_blocks = list(string)
    description      = optional(string, "Ingress IPv6")
  }))
  default = []
}

variable "ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks to apply to all predefined ingress rules."
  type        = list(string)
  default     = []
}

# =============================================================================
# Ingress Rules - Source Security Groups
# =============================================================================

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules with source security group IDs."
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
    description              = optional(string, "Ingress from SG")
  }))
  default = []
}

# =============================================================================
# Ingress Rules - Self
# =============================================================================

variable "ingress_with_self" {
  description = "List of ingress rules allowing traffic from the security group itself."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = optional(string, "Ingress from self")
  }))
  default = []
}

# =============================================================================
# Ingress Rules - Prefix Lists
# =============================================================================

variable "ingress_with_prefix_list_ids" {
  description = "List of ingress rules with prefix list IDs."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    prefix_list_ids = list(string)
    description     = optional(string, "Ingress Prefix List")
  }))
  default = []
}

# =============================================================================
# Egress Rules - Predefined
# =============================================================================

variable "egress_rules" {
  description = "List of predefined egress rule names to create. Uses same rule names as ingress_rules."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      contains([
        "http-80-tcp", "https-443-tcp", "ssh-tcp",
        "postgresql-tcp", "mysql-tcp",
        "aurora-postgresql-tcp", "aurora-mysql-tcp",
        "redis-tcp", "mongodb-tcp",
        "elasticsearch-tcp", "kafka-tcp", "rabbitmq-tcp",
        "dns-udp", "dns-tcp", "nfs-tcp",
        "all-all", "all-icmp"
      ], rule)
    ])
    error_message = "Una o más reglas de egress no son válidas. Consulta la descripción de la variable para ver las reglas disponibles."
  }
}

# =============================================================================
# Egress Rules - CIDR Blocks
# =============================================================================

variable "egress_with_cidr_blocks" {
  description = "List of egress rules with CIDR blocks."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string, "Egress Rule")
  }))
  default = []
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks to apply to all predefined egress rules."
  type        = list(string)
  default     = []
}

# =============================================================================
# Egress Rules - IPv6 CIDR Blocks
# =============================================================================

variable "egress_with_ipv6_cidr_blocks" {
  description = "List of egress rules with IPv6 CIDR blocks."
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    ipv6_cidr_blocks = list(string)
    description      = optional(string, "Egress IPv6")
  }))
  default = []
}

variable "egress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks to apply to all predefined egress rules."
  type        = list(string)
  default     = []
}

# =============================================================================
# Egress Rules - Source Security Groups
# =============================================================================

variable "egress_with_source_security_group_id" {
  description = "List of egress rules with source security group IDs."
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
    description              = optional(string, "Egress to SG")
  }))
  default = []
}

# =============================================================================
# Egress Rules - Self
# =============================================================================

variable "egress_with_self" {
  description = "List of egress rules allowing traffic to the security group itself."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = optional(string, "Egress to self")
  }))
  default = []
}

# =============================================================================
# Egress Rules - Prefix Lists
# =============================================================================

variable "egress_with_prefix_list_ids" {
  description = "List of egress rules with prefix list IDs."
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    prefix_list_ids = list(string)
    description     = optional(string, "Egress Prefix List")
  }))
  default = []
}

# =============================================================================
# Revoke Rules on Delete
# =============================================================================

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all security group rules before deleting the group."
  type        = bool
  default     = false
}
