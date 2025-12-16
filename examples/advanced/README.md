# Advanced Security Group Example

This example demonstrates advanced security group configurations showcasing all available features of the module.

## Features

- **Multiple Rule Types**: Predefined rules, custom CIDR blocks, IPv6, source security groups, self-referencing rules
- **Name Prefix**: Uses `use_name_prefix = true` for dynamic naming
- **Self-Referencing Rules**: Allows traffic between instances in the same security group
- **IPv6 Support**: Demonstrates IPv6 CIDR block rules
- **Complex Configurations**: Shows how to combine multiple rule types in a single security group
- **Minimal Configuration**: Also includes a minimal security group example for comparison

## Use Cases

### Advanced Security Group
- Microservices architecture where services need to communicate with each other
- Applications requiring multiple types of network access patterns
- Production environments with complex security requirements

### Minimal Security Group
- Simple HTTPS-only applications
- Quick testing or development environments

## Usage

```bash
cd examples/advanced
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## What Gets Created

1. **Advanced Security Group** with:
   - Predefined rules for HTTP (80), HTTPS (443), and SSH (22)
   - Custom application port (8080) from specific subnets
   - Monitoring ports (9090-9099) from VPC
   - IPv6 HTTPS access
   - Self-referencing rules for intra-group communication
   - Egress to all destinations and specific database subnet

2. **Minimal Security Group** with:
   - Only HTTPS (443) ingress from anywhere
   - All egress traffic allowed

## Outputs

- `advanced_sg_id`: The ID of the advanced security group
- `advanced_sg_name`: The name of the advanced security group
- `advanced_sg_ingress_rules`: Summary of all ingress rules created
- `minimal_sg_id`: The ID of the minimal security group
- `minimal_sg_name`: The name of the minimal security group
