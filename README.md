# Terraform AWS Security Group Module

Production-ready Terraform module for creating and managing AWS Security Groups with flexible rule definitions.

## Features

- **Predefined Rules**: Built-in rules for common services (HTTP, HTTPS, SSH, databases, etc.)
- **Flexible Rule Types**: Support for CIDR blocks, IPv6, source security groups, self-referencing, and prefix lists
- **Multiple Naming Options**: Fixed names or name prefixes for resource management
- **VPC Security Group Rules**: Uses modern `aws_vpc_security_group_*_rule` resources
- **Comprehensive Outputs**: Detailed outputs for security group attributes and rule IDs
- **Best Practices**: Follows AWS security best practices and Terraform conventions

## Usage

### Basic Example

```hcl
module "web_sg" {
  source = "./security-group"

  account_name = "dev"
  project_name = "webapp"

  description = "Security group for web servers"
  vpc_id      = "vpc-12345678"

  # Predefined rules
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Allow all egress
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "Development"
  }
}
```

### Database Security Group

```hcl
module "db_sg" {
  source = "./security-group"

  account_name = "prod"
  project_name = "database"

  vpc_id = "vpc-12345678"

  # Custom rules for database access
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      description = "PostgreSQL from private subnets"
    }
  ]

  # Allow traffic from application security group
  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.app_sg.security_group_id
      description              = "PostgreSQL from application servers"
    }
  ]
}
```

### Advanced Configuration

```hcl
module "advanced_sg" {
  source = "./security-group"

  account_name    = "prod"
  project_name    = "microservices"
  use_name_prefix = true

  vpc_id = "vpc-12345678"

  # Multiple rule types
  ingress_rules       = ["https-443-tcp"]
  ingress_cidr_blocks = ["10.0.0.0/8"]

  # Self-referencing rules
  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow all TCP within security group"
    }
  ]

  # IPv6 support
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      description      = "HTTPS from anywhere (IPv6)"
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
```

## Predefined Rules

The module includes predefined rules for common services:

| Rule Name              | Port(s) | Protocol | Description              |
|------------------------|---------|----------|--------------------------|
| `http-80-tcp`          | 80      | TCP      | HTTP                     |
| `https-443-tcp`        | 443     | TCP      | HTTPS                    |
| `ssh-tcp`              | 22      | TCP      | SSH                      |
| `postgresql-tcp`       | 5432    | TCP      | PostgreSQL               |
| `mysql-tcp`            | 3306    | TCP      | MySQL/Aurora MySQL       |
| `aurora-postgresql-tcp`| 5432    | TCP      | Aurora PostgreSQL        |
| `aurora-mysql-tcp`     | 3306    | TCP      | Aurora MySQL             |
| `redis-tcp`            | 6379    | TCP      | Redis                    |
| `mongodb-tcp`          | 27017   | TCP      | MongoDB                  |
| `elasticsearch-tcp`    | 9200-9300| TCP     | Elasticsearch            |
| `kafka-tcp`            | 9092    | TCP      | Kafka                    |
| `rabbitmq-tcp`         | 5672    | TCP      | RabbitMQ                 |
| `dns-udp`              | 53      | UDP      | DNS                      |
| `dns-tcp`              | 53      | TCP      | DNS                      |
| `nfs-tcp`              | 2049    | TCP      | NFS                      |
| `all-all`              | 0       | -1       | All protocols            |
| `all-icmp`             | -1      | ICMP     | All ICMP                 |

## Inputs

### General Configuration

| Name                    | Description                                      | Type     | Default           | Required |
|-------------------------|--------------------------------------------------|----------|-------------------|----------|
| `create`                | Whether to create security group and rules      | `bool`   | `true`            | no       |
| `create_sg`             | Whether to create security group                | `bool`   | `true`            | no       |
| `security_group_id`     | ID of existing security group                   | `string` | `null`            | no       |
| `vpc_id`                | VPC ID where security group will be created     | `string` | `null`            | no       |

### Naming

| Name                    | Description                                      | Type          | Default           | Required |
|-------------------------|--------------------------------------------------|---------------|-------------------|----------|
| `account_name`          | Account name for resource naming                | `string`      | -                 | yes      |
| `project_name`          | Project name for resource naming                | `string`      | -                 | yes      |
| `name`                  | Security group name                             | `string`      | `null`            | no       |
| `use_name_prefix`       | Use name_prefix instead of name                 | `bool`        | `false`           | no       |
| `region_prefix`         | Region prefix for naming                        | `string`      | `null`            | no       |
| `description`           | Security group description                      | `string`      | `"Managed by Terraform"` | no |
| `tags`                  | Additional tags                                 | `map(string)` | `{}`              | no       |

### Ingress Rules

| Name                                       | Description                                | Type           | Default | Required |
|--------------------------------------------|-------------------------------------------|----------------|---------|----------|
| `ingress_rules`                            | List of predefined ingress rule names     | `list(string)` | `[]`    | no       |
| `ingress_cidr_blocks`                      | CIDR blocks for predefined ingress rules  | `list(string)` | `[]`    | no       |
| `ingress_with_cidr_blocks`                 | Ingress rules with CIDR blocks            | `list(object)` | `[]`    | no       |
| `ingress_ipv6_cidr_blocks`                 | IPv6 CIDR blocks for predefined rules     | `list(string)` | `[]`    | no       |
| `ingress_with_ipv6_cidr_blocks`            | Ingress rules with IPv6 CIDR blocks       | `list(object)` | `[]`    | no       |
| `ingress_with_source_security_group_id`    | Ingress rules with source SG IDs          | `list(object)` | `[]`    | no       |
| `ingress_with_self`                        | Ingress rules with self reference         | `list(object)` | `[]`    | no       |
| `ingress_with_prefix_list_ids`             | Ingress rules with prefix list IDs        | `list(object)` | `[]`    | no       |

### Egress Rules

| Name                                       | Description                                | Type           | Default | Required |
|--------------------------------------------|-------------------------------------------|----------------|---------|----------|
| `egress_rules`                             | List of predefined egress rule names      | `list(string)` | `[]`    | no       |
| `egress_cidr_blocks`                       | CIDR blocks for predefined egress rules   | `list(string)` | `[]`    | no       |
| `egress_with_cidr_blocks`                  | Egress rules with CIDR blocks             | `list(object)` | `[]`    | no       |
| `egress_ipv6_cidr_blocks`                  | IPv6 CIDR blocks for predefined rules     | `list(string)` | `[]`    | no       |
| `egress_with_ipv6_cidr_blocks`             | Egress rules with IPv6 CIDR blocks        | `list(object)` | `[]`    | no       |
| `egress_with_source_security_group_id`     | Egress rules with source SG IDs           | `list(object)` | `[]`    | no       |
| `egress_with_self`                         | Egress rules with self reference          | `list(object)` | `[]`    | no       |
| `egress_with_prefix_list_ids`              | Egress rules with prefix list IDs         | `list(object)` | `[]`    | no       |

### Other

| Name                     | Description                                     | Type   | Default | Required |
|--------------------------|------------------------------------------------|--------|---------|----------|
| `revoke_rules_on_delete` | Revoke all rules before deleting security group| `bool` | `false` | no       |

## Outputs

| Name                          | Description                                    |
|-------------------------------|------------------------------------------------|
| `security_group_id`           | The ID of the security group                   |
| `security_group_arn`          | The ARN of the security group                  |
| `security_group_name`         | The name of the security group                 |
| `security_group_vpc_id`       | The VPC ID of the security group               |
| `security_group_owner_id`     | The owner ID of the security group             |
| `security_group_description`  | The description of the security group          |
| `ingress_rules`               | Summary of ingress rules created               |
| `egress_rules`                | Summary of egress rules created                |

## Requirements

| Name       | Version   |
|------------|-----------|
| terraform  | >= 1.5.0  |
| aws        | >= 5.0    |

## Examples

See the [examples](./examples) directory for complete usage examples:

- [Basic](./examples/basic) - Simple web security group with HTTP/HTTPS
- [Database](./examples/database) - Database security groups with restricted access
- [Advanced](./examples/advanced) - Complex multi-rule security groups

## Region Prefixes

The module automatically determines region prefixes for resource naming:

| Region          | Prefix  |
|-----------------|---------|
| us-east-1       | ause1   |
| us-east-2       | ause2   |
| us-west-1       | usw1    |
| us-west-2       | usw2    |
| eu-west-1       | euw1    |
| eu-central-1    | euc1    |
| ap-southeast-1  | apse1   |
| ap-northeast-1  | apne1   |

You can override this with the `region_prefix` variable.

## Security Group Naming

By default, security groups are named:
```
{region_prefix}-sg-{account_name}-{project_name}
```

Example: `ause1-sg-prod-webapp`

When `use_name_prefix = true`, a name prefix is used instead:
```
{region_prefix}-sg-{account_name}-{project_name}-
```

You can also provide a custom name via the `name` variable.

## License

MIT License - see [LICENSE](./LICENSE) for details.

## Author

Created and maintained by [Jhon Meza](https://github.com/jhonmezaa).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
