# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-16

### 🎉 Initial Release

First production-ready release of the AWS Security Group Terraform module with comprehensive rule management capabilities.

### Added

#### Core Security Group Features
- Security group creation with customizable configuration
- Support for fixed names and name prefixes
- VPC association
- Revoke rules on delete option
- Automatic region prefix generation for resource naming
- Consistent resource naming convention across all resources

#### Naming Convention
- Automatic region prefix mapping for 20+ AWS regions
- Fixed name: `{region_prefix}-sg-{account_name}-{project_name}`
- Name prefix support: `{region_prefix}-sg-{account_name}-{project_name}-`
- Custom name override via `name` variable

#### Predefined Rules
- **Web Services**: http-80-tcp, https-443-tcp
- **Remote Access**: ssh-tcp
- **Databases**:
  - PostgreSQL (postgresql-tcp, aurora-postgresql-tcp)
  - MySQL (mysql-tcp, aurora-mysql-tcp)
  - Redis (redis-tcp)
  - MongoDB (mongodb-tcp)
  - Elasticsearch (elasticsearch-tcp)
- **Messaging**: kafka-tcp, rabbitmq-tcp
- **DNS**: dns-udp, dns-tcp
- **Storage**: nfs-tcp
- **General**: all-all, all-icmp

#### Ingress Rules - Multiple Types
- **Predefined rules**: Use common rule names with CIDR blocks
- **CIDR blocks**: Custom rules with IPv4 CIDR blocks
- **IPv6 CIDR blocks**: Custom rules with IPv6 support
- **Source security groups**: Rules referencing other security groups
- **Self-referencing**: Rules allowing traffic within the same security group
- **Prefix lists**: Rules using AWS managed prefix lists
- Dynamic rule creation using for_each pattern

#### Egress Rules - Multiple Types
- **Predefined rules**: Use common rule names with CIDR blocks
- **CIDR blocks**: Custom rules with IPv4 CIDR blocks
- **IPv6 CIDR blocks**: Custom rules with IPv6 support
- **Destination security groups**: Rules targeting other security groups
- **Self-referencing**: Rules allowing traffic within the same security group
- **Prefix lists**: Rules using AWS managed prefix lists
- Dynamic rule creation using for_each pattern

#### Modern VPC Security Group Rules
- Uses `aws_vpc_security_group_ingress_rule` resources
- Uses `aws_vpc_security_group_egress_rule` resources
- Better dependency management than inline rules
- Prevents rule conflicts and race conditions

#### Flexible Configuration
- Create or use existing security group
- Conditional resource creation via `create` and `create_sg` flags
- Support for both ingress and egress rules
- Optional descriptions for all rules
- Tags support for resource organization

#### Outputs (8 total)
- Security group attributes (ID, ARN, name, VPC ID, owner ID, description)
- Ingress rules summary (all rule types with IDs)
- Egress rules summary (all rule types with IDs)

#### Examples
- **basic**: Simple web security group with HTTP/HTTPS access
- **database**: Database security group with restricted access from specific subnets and security groups
- **advanced**: Complex multi-rule setup with IPv6, self-referencing, and multiple rule types

#### Documentation
- Comprehensive README with usage examples
- Complete variable documentation
- Output variable documentation
- Predefined rules reference table
- Region prefix mapping
- Integration examples

#### Code Quality
- Terraform 1.5+ compatibility
- AWS Provider 5.0+ compatibility
- Numbered file organization (0-7)
- Consistent code formatting
- Comprehensive variable validation
- Terraform validate passing for module and all examples
- For-each pattern for all rules
- Dynamic blocks for optional features

### Technical Details

#### Supported Regions
- All AWS commercial regions
- Automatic region prefix mapping for 20+ regions
- Custom region prefix override support

#### Resource Limits
- Security groups: 2,500 per VPC (AWS default)
- Rules per security group: 60 inbound, 60 outbound (AWS default)
- AWS service quotas apply

#### Performance
- Efficient use of for_each over count
- Minimal resource dependencies
- Optimized data source queries
- Lazy evaluation of optional resources

#### Compatibility
- Terraform >= 1.5.0
- AWS Provider >= 5.0
- Compatible with Terraform Cloud
- Compatible with Terragrunt
- Module composition ready

### Dependencies

#### Required Providers
- hashicorp/aws >= 5.0

#### Terraform Version
- terraform >= 1.5.0

### Notes

- This is the first stable release (1.0.0)
- All features are production-ready
- Breaking changes will follow semantic versioning
- See examples for recommended usage patterns

### Migration Notes

This is the first release - no migration needed.

### Known Issues

None reported in this release.

### Contributors

- Initial implementation and release

---

## Release Checklist

- [x] All examples validated with `terraform validate`
- [x] README.md documentation complete
- [x] CHANGELOG.md created
- [x] All input variables documented
- [x] All outputs documented
- [x] Code formatted with `terraform fmt`
- [x] Examples cover all major use cases
- [x] Naming conventions consistent
- [x] Security best practices implemented
- [x] terraform.tfvars.example added to all examples
- [x] README.md added to each example

[1.0.0]: https://github.com/jhonmezaa/terraform-aws-security-group/releases/tag/v1.0.0
