# Basic Security Group Example

This example demonstrates creating a basic security group with predefined rules for HTTP and HTTPS traffic.

## Features

- Uses predefined rules (`http-80-tcp`, `https-443-tcp`)
- Allows traffic from any IP address (0.0.0.0/0)
- Allows all egress traffic
- Uses default VPC for simplicity

## Usage

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## Outputs

- `security_group_id`: The ID of the created security group
- `security_group_name`: The name of the created security group
