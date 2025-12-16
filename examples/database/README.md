# Database Security Group Example

This example demonstrates creating security groups for database access with PostgreSQL and MySQL rules from specific CIDR blocks and source security groups.

## Features

- Creates two security groups: one for application servers and one for databases
- Uses custom ingress rules with CIDR blocks for database ports
- Uses source security group references for application-to-database communication
- Demonstrates security best practices for database access control

## Architecture

```
Application Security Group
         |
         | (references)
         v
Database Security Group
  - PostgreSQL (5432) from 10.0.1.0/24, 10.0.2.0/24, and app SG
  - MySQL (3306) from 10.0.1.0/24
```

## Usage

```bash
cd examples/database
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```

## Outputs

- `app_security_group_id`: The ID of the application security group
- `db_security_group_id`: The ID of the database security group
- `db_security_group_name`: The name of the database security group
