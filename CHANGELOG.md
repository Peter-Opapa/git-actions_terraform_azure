# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Actions workflows for automated Terraform deployments
- Multi-environment support (dev/staging/production)
- Azure Service Principal setup scripts (Bash and PowerShell)
- Comprehensive documentation for GitHub Actions setup
- VS Code workspace configuration with recommended extensions
- Security policy and contributing guidelines
- Professional project structure and organization
- Production environment configuration
- Dedicated documentation directory with architecture diagrams
- Infrastructure-specific README with detailed guidance

### Changed
- **BREAKING**: Restructured project from `lessons/day26/` to professional `infrastructure/` layout
- **BREAKING**: Updated GitHub Actions workflows to use new directory structure
- Improved .gitignore with comprehensive exclusions
- Enhanced README with quick start guide
- Updated Terraform configurations for better GitHub Actions integration
- Standardized naming conventions across all environments
- Organized legacy files into dedicated `legacy/` directory
- Moved documentation and diagrams to `docs/` directory

### Security
- Separated CI/CD credentials from application credentials
- Implemented secure secret management with Azure Key Vault
- Added environment protection rules for staging/production
- Configured least privilege access for Service Principals

## [1.0.0] - 2025-08-07

### Added
- Initial Terraform configuration for Azure infrastructure
- Azure DevOps pipeline configurations (legacy)
- AKS cluster deployment with Service Principal authentication
- Key Vault integration for secret management
- Multi-environment support (dev/staging)
- Modular Terraform architecture
- Service Principal, AKS, and Key Vault modules

### Infrastructure Components
- Azure Resource Groups
- Azure Kubernetes Service (AKS)
- Azure Key Vault
- Service Principals for authentication
- Role assignments and permissions

### Environments
- **Development**: `dev-peter-rg` resource group
- **Staging**: `stage-peter-rg` resource group
- **Backend**: `terraform-state-rg` for state management

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2025-08-07 | Initial release with Azure DevOps |
| 1.1.0 | 2025-08-07 | GitHub Actions integration |

---

## Migration Notes

### From Azure DevOps to GitHub Actions

If migrating from the Azure DevOps pipelines to GitHub Actions:

1. **Backup existing state**: Ensure Terraform state is backed up
2. **Create GitHub secrets**: Follow the [setup guide](./GITHUB_ACTIONS_SETUP.md)
3. **Test in dev environment**: Validate deployment before production
4. **Update variables**: Check `terraform.tfvars` files for environment-specific values
5. **Configure environments**: Set up GitHub environment protection rules

### Breaking Changes

- **Directory Structure**: Project restructured from `lessons/day26/` to `infrastructure/` 
- **Service Principal**: New SP required for GitHub Actions (separate from Azure DevOps)
- **Backend configuration**: Updated to use dynamic backend configuration
- **Variable names**: Standardized variable naming conventions
- **Workflow paths**: GitHub Actions workflows updated for new directory structure

### Migration Guide

If upgrading from the old structure:

1. **Backup your state**: Ensure all Terraform state files are backed up
2. **Update local clones**: Re-clone repository or manually update directory references
3. **Update CI/CD**: GitHub Actions workflows automatically updated
4. **Review configurations**: Check `terraform.tfvars` files in new environment directories
5. **Test deployments**: Validate in development environment first

---

## Support

For questions about specific versions or upgrade paths:

- 📖 Check the [documentation](./GITHUB_ACTIONS_SETUP.md)
- 🐛 Open an [issue](https://github.com/Peter-Opapa/Terraform-Azure/issues)
- 💬 Start a [discussion](https://github.com/Peter-Opapa/Terraform-Azure/discussions)

---

**Note**: This changelog will be updated with each release following semantic versioning principles.
