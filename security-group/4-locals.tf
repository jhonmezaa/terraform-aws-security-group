locals {
  # =============================================================================
  # Region Prefix Mapping
  # =============================================================================

  region_prefix_map = {
    # US Regions
    "us-east-1"      = "ause1"
    "us-east-2"      = "ause2"
    "us-west-1"      = "ausw1"
    "us-west-2"      = "ausw2"
    # EU Regions
    "eu-west-1"      = "euwe1"
    "eu-west-2"      = "euwe2"
    "eu-west-3"      = "euwe3"
    "eu-central-1"   = "euce1"
    "eu-central-2"   = "euce2"
    "eu-north-1"     = "euno1"
    "eu-south-1"     = "euso1"
    "eu-south-2"     = "euso2"
    # AP Regions
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ap-southeast-3" = "apse3"
    "ap-southeast-4" = "apse4"
    "ap-northeast-1" = "apne1"
    "ap-northeast-2" = "apne2"
    "ap-northeast-3" = "apne3"
    "ap-south-1"     = "apso1"
    "ap-south-2"     = "apso2"
    "ap-east-1"      = "apea1"
    # SA Regions
    "sa-east-1"      = "saea1"
    # CA Regions
    "ca-central-1"   = "cace1"
    "ca-west-1"      = "cawe1"
    # ME Regions
    "me-south-1"     = "meso1"
    "me-central-1"   = "mece1"
    # AF Regions
    "af-south-1"     = "afso1"
    # IL Regions
    "il-central-1"   = "ilce1"
  }

  region_prefix = var.region_prefix != null ? var.region_prefix : lookup(
    local.region_prefix_map,
    data.aws_region.current.id,
    data.aws_region.current.id
  )

  # =============================================================================
  # Predefined Rules for Common Services
  # =============================================================================

  rules = {
    # HTTP
    http-80-tcp = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
    }
    # HTTPS
    https-443-tcp = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
    }
    # SSH
    ssh-tcp = {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
    }
    # PostgreSQL
    postgresql-tcp = {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL"
    }
    # MySQL/Aurora MySQL
    mysql-tcp = {
      type        = "ingress"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL/Aurora"
    }
    # Aurora PostgreSQL
    aurora-postgresql-tcp = {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Aurora PostgreSQL"
    }
    # Aurora MySQL
    aurora-mysql-tcp = {
      type        = "ingress"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Aurora MySQL"
    }
    # Redis
    redis-tcp = {
      type        = "ingress"
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      description = "Redis"
    }
    # MongoDB
    mongodb-tcp = {
      type        = "ingress"
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      description = "MongoDB"
    }
    # Elasticsearch
    elasticsearch-tcp = {
      type        = "ingress"
      from_port   = 9200
      to_port     = 9300
      protocol    = "tcp"
      description = "Elasticsearch"
    }
    # Kafka
    kafka-tcp = {
      type        = "ingress"
      from_port   = 9092
      to_port     = 9092
      protocol    = "tcp"
      description = "Kafka"
    }
    # RabbitMQ
    rabbitmq-tcp = {
      type        = "ingress"
      from_port   = 5672
      to_port     = 5672
      protocol    = "tcp"
      description = "RabbitMQ"
    }
    # DNS
    dns-udp = {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      description = "DNS"
    }
    dns-tcp = {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      description = "DNS"
    }
    # NFS
    nfs-tcp = {
      type        = "ingress"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "NFS"
    }
    # All traffic
    all-all = {
      type        = "ingress"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      description = "All protocols"
    }
    # ICMP
    all-icmp = {
      type        = "ingress"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      description = "All ICMP"
    }
  }

  # =============================================================================
  # Security Group Creation Logic
  # =============================================================================

  create            = var.create
  create_sg         = var.create && var.create_sg
  use_name_prefix   = var.use_name_prefix
  security_group_id = var.security_group_id

  sg_name = var.name != null ? var.name : (
    local.use_name_prefix ? null : "${local.region_prefix}-sg-${var.account_name}-${var.project_name}"
  )

  sg_name_prefix = local.use_name_prefix ? (
    var.name != null ? "${var.name}-" : "${local.region_prefix}-sg-${var.account_name}-${var.project_name}-"
  ) : null

  # Base name for Name tag (without trailing dash when using name_prefix)
  sg_name_tag = var.name != null ? var.name : "${local.region_prefix}-sg-${var.account_name}-${var.project_name}"

  # Get the security group ID (created or provided)
  this_sg_id = try(
    coalescelist(
      aws_security_group.this[*].id,
      aws_security_group.this_name_prefix[*].id,
      [local.security_group_id]
    )[0],
    null
  )

  # =============================================================================
  # Ingress Rules Processing
  # =============================================================================

  # Named ingress rules from predefined rules
  ingress_rules = [
    for rule_name in var.ingress_rules : merge(
      local.rules[rule_name],
      {
        rule_name = rule_name
        key       = rule_name
      }
    ) if contains(keys(local.rules), rule_name) && local.rules[rule_name].type == "ingress"
  ]

  # Ingress with CIDR blocks
  ingress_with_cidr_blocks = flatten([
    for idx, rule in var.ingress_with_cidr_blocks : [
      for cidr_idx, cidr in rule.cidr_blocks : {
        key         = "${idx}-cidr-${cidr_idx}"
        description = lookup(rule, "description", "Ingress Rule")
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv4   = cidr
      }
    ]
  ])

  # Ingress with IPv6 CIDR blocks
  ingress_with_ipv6_cidr_blocks = flatten([
    for idx, rule in var.ingress_with_ipv6_cidr_blocks : [
      for cidr_idx, cidr in rule.ipv6_cidr_blocks : {
        key         = "${idx}-ipv6-${cidr_idx}"
        description = lookup(rule, "description", "Ingress IPv6")
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv6   = cidr
      }
    ]
  ])

  # Ingress with source security group ID
  ingress_with_source_security_group_id = [
    for idx, rule in var.ingress_with_source_security_group_id : merge(rule, {
      key = "${idx}-sg"
    })
  ]

  # Ingress with self
  ingress_with_self = [
    for idx, rule in var.ingress_with_self : merge(rule, {
      key = "${idx}-self"
    })
  ]

  # Ingress with prefix list IDs
  ingress_with_prefix_list_ids = flatten([
    for idx, rule in var.ingress_with_prefix_list_ids : [
      for pl_idx, pl_id in rule.prefix_list_ids : {
        key            = "${idx}-pl-${pl_idx}"
        description    = lookup(rule, "description", "Ingress Prefix List")
        from_port      = rule.from_port
        to_port        = rule.to_port
        protocol       = rule.protocol
        prefix_list_id = pl_id
      }
    ]
  ])

  # =============================================================================
  # Egress Rules Processing
  # =============================================================================

  # Named egress rules from predefined rules
  egress_rules = [
    for rule_name in var.egress_rules : merge(
      local.rules[rule_name],
      {
        rule_name = rule_name
        key       = rule_name
      }
    ) if contains(keys(local.rules), rule_name)
  ]

  # Egress with CIDR blocks
  egress_with_cidr_blocks = flatten([
    for idx, rule in var.egress_with_cidr_blocks : [
      for cidr_idx, cidr in rule.cidr_blocks : {
        key         = "${idx}-cidr-${cidr_idx}"
        description = lookup(rule, "description", "Egress Rule")
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv4   = cidr
      }
    ]
  ])

  # Egress with IPv6 CIDR blocks
  egress_with_ipv6_cidr_blocks = flatten([
    for idx, rule in var.egress_with_ipv6_cidr_blocks : [
      for cidr_idx, cidr in rule.ipv6_cidr_blocks : {
        key         = "${idx}-ipv6-${cidr_idx}"
        description = lookup(rule, "description", "Egress IPv6")
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_ipv6   = cidr
      }
    ]
  ])

  # Egress with source security group ID
  egress_with_source_security_group_id = [
    for idx, rule in var.egress_with_source_security_group_id : merge(rule, {
      key = "${idx}-sg"
    })
  ]

  # Egress with self
  egress_with_self = [
    for idx, rule in var.egress_with_self : merge(rule, {
      key = "${idx}-self"
    })
  ]

  # Egress with prefix list IDs
  egress_with_prefix_list_ids = flatten([
    for idx, rule in var.egress_with_prefix_list_ids : [
      for pl_idx, pl_id in rule.prefix_list_ids : {
        key            = "${idx}-pl-${pl_idx}"
        description    = lookup(rule, "description", "Egress Prefix List")
        from_port      = rule.from_port
        to_port        = rule.to_port
        protocol       = rule.protocol
        prefix_list_id = pl_id
      }
    ]
  ])
}
