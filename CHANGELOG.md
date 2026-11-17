# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.3.0] - 2026-11-17

### Added

- `tags_common` variable: common tags merged into every resource (`merge(tags_common, tags, { Name, ManagedBy })`)
- `region` variable (AWS provider v6 per-resource region) for the security group, rules and VPC associations; the region prefix is derived from it when set
- `timeouts` variable (`create` / `delete`) for the security group, matching the upstream module
- `vpc_associations` variable and output, backed by `aws_vpc_security_group_vpc_association`, to associate the security group with additional VPCs
- Validation: `name` cannot start with `sg-` (AWS restriction) and must be at most 255 characters
- Precondition: `security_group_id` is required when `create_sg = false`

### Fixed

- `ingress_ipv6_cidr_blocks` / `egress_ipv6_cidr_blocks` were declared and documented but ignored: predefined rules are now created for every IPv6 CIDR (`*_rules_ipv6` resources)
- Predefined rules without any CIDR produced rules with no source that failed at apply time; the plan now fails early with a clear precondition error. When only IPv6 CIDRs are given, no IPv4 rule is planned
- `ingress_rules.predefined` / `egress_rules.predefined` outputs now include the rules created for additional IPv4 CIDRs and for IPv6 CIDRs
- Rules created from `*_with_*` inputs now get `Name` and `ManagedBy` tags (previously only `var.tags`)
- `use_region_prefix` description and README naming section: without the region prefix the name is `{account}-{project}-sg`, not `sg-{account}-{project}`
- README: `source` uses the GitHub URL with `?ref=`, documents all inputs/outputs (`use_region_prefix` was missing), and the `all-all` port column
- Example `terraform.tfvars.example` files referenced variable names that do not exist

### Changed

- Removed the unused `aws_caller_identity` and `aws_partition` data sources
- `examples/advanced` shows dual-stack predefined egress and `tags_common`
- Normalized line endings of `5-outputs.tf` and `6-variables.tf` to LF

### Upgrade notes

- No resource is recreated. Tag changes are applied in place:
  - The `Name` and `ManagedBy` tags of the security group and predefined rules now take precedence over `var.tags` (previously a `Name` in `var.tags` overrode the generated one)
  - Rules from `*_with_*` inputs gain `Name` and `ManagedBy` tags
- If you set `ingress_ipv6_cidr_blocks` / `egress_ipv6_cidr_blocks` together with predefined rules, the corresponding IPv6 rules will now be created

## [v1.2.4] - 2026-10-27

### Changed

- Normalize CHANGELOG: preamble moved to the top, all headings use the `## [vX.Y.Z] - YYYY-MM-DD` format, entries sorted by version (newest first)
- Add missing entry for v1.2.1, reconstructed from git history

## [v1.2.3] - 2026-10-27

### Fixed

- Replace deprecated `data.aws_region.current.id` with `data.aws_region.current.region` (deprecated in AWS provider v6) in module locals

## [v1.2.2] - 2026-10-27

### Changed

- Use minimum-only version constraints in the reusable module, following HashiCorp guidance for shared modules: AWS provider `~> 6.0` -> `>= 6.0`
- Set module `required_version` to `>= 1.3` (was `~> 1.0`): the module uses `optional()` object type attributes (with defaults), which require Terraform 1.3; no newer features (`moved`/`import`/`check`/`removed`, cross-variable validations, provider-defined functions, ephemeral resources) are used
- Examples (root modules) keep pessimistic constraints: `required_version` `~> 1.3`, AWS provider `~> 6.0`
- Update Terraform and provider requirements in README

## [v1.2.1] - 2026-02-28

### Changed

- Update README and CHANGELOG documentation

## [v1.2.0] - 2026-02-27

### Added

- `use_region_prefix` boolean variable (default: `true`) to control whether the region prefix is included in security group names. When `false`, names omit the prefix (e.g., `sg-prod-myapp` instead of `ause1-sg-prod-myapp`)

## [v1.1.2] - 2026-02-27

### Changed

- Standardize Terraform `required_version` to `~> 1.0` across module and examples

## [v1.1.1] - 2026-02-27

### Changed

- Update AWS provider constraint to `~> 6.0` across module and examples

## [v1.1.0] - 2025-12-31

### Added

#### Variable Validations

- Added validation for `account_name` variable:
  - Must be between 1-32 characters
  - Only allows lowercase letters, numbers, and hyphens
- Added validation for `project_name` variable:
  - Must be between 1-32 characters
  - Only allows lowercase letters, numbers, and hyphens
- Added validation for `ingress_rules` variable:
  - Validates that predefined rule names exist in the available rules list
  - Provides clear error messages with available options
- Added validation for `egress_rules` variable:
  - Validates that predefined rule names exist in the available rules list
  - Provides clear error messages with available options

#### Region Support

- Expanded region prefix mapping from 8 to 29 AWS regions:
  - **US Regions**: us-east-1, us-east-2, us-west-1, us-west-2
  - **EU Regions**: eu-west-1/2/3, eu-central-1/2, eu-north-1, eu-south-1/2
  - **AP Regions**: ap-southeast-1/2/3/4, ap-northeast-1/2/3, ap-south-1/2, ap-east-1
  - **SA Regions**: sa-east-1
  - **CA Regions**: ca-central-1, ca-west-1
  - **ME Regions**: me-south-1, me-central-1
  - **AF Regions**: af-south-1
  - **IL Regions**: il-central-1

#### Examples

- Added new `minimal` example demonstrating the simplest possible usage:
  - Single HTTP ingress rule from 0.0.0.0/0
  - All egress traffic allowed
  - Complete documentation and terraform.tfvars.example
  - Perfect for quick start and learning

### Changed

#### Documentation

- Updated variable descriptions with validation rules
- Enhanced error messages for better debugging experience
- Improved region prefix documentation with complete list

### Technical Details

- **Breaking Changes**: None
- **Deprecations**: None
- **Migration Required**: No
- **Terraform Version**: >= 1.5.0
- **AWS Provider Version**: >= 5.0

## [v1.0.1] - 2024-12-16

### Changed

#### Documentation

- Updated CHANGELOG release checklist to mark all items as completed
- All examples now include terraform.tfvars.example and README.md files

## [v1.0.0] - 2024-12-16

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

[v1.0.1]: https://github.com/jhonmezaa/terraform-aws-security-group/releases/tag/v1.0.1
[v1.0.0]: https://github.com/jhonmezaa/terraform-aws-security-group/releases/tag/v1.0.0
