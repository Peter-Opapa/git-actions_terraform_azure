# Infrastructure Documentation

This directory contains the complete Azure infrastructure as code using Terraform.

## 🏗️ Architecture Overview

The infrastructure follows enterprise-grade patterns with clear separation of environments and reusable modules.

## 📁 Directory Structure

```
infrastructure/
├── 📁 environments/           # Environment-specific configurations
│   ├── 📁 development/       # Development environment
│   ├── 📁 staging/           # Staging environment
│   └── 📁 production/        # Production environment
├── 📁 modules/               # Reusable Terraform modules
│   ├── 📁 aks/              # Azure Kubernetes Service
│   ├── 📁 keyvault/         # Azure Key Vault
│   └── 📁 ServicePrincipal/ # Service Principal management
└── 📁 shared/               # Shared configurations
    ├── providers.tf         # Provider configurations
    └── outputs.tf          # Global outputs
```

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and authenticated
- Terraform >= 1.5.7
- Appropriate Azure permissions

### Deployment

1. **Navigate to environment**
   ```bash
   cd infrastructure/environments/development
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Plan deployment**
   ```bash
   terraform plan -var-file=terraform.tfvars
   ```

4. **Apply configuration**
   ```bash
   terraform apply -var-file=terraform.tfvars
   ```

## 🌍 Environments

### Development
- **Resource Group**: `dev-peter-rg`
- **Key Vault**: `dev-peter-kv-101`
- **AKS Cluster**: `dev-peter-cluster`
- **State Key**: `dev.tfstate`

### Staging
- **Resource Group**: `stage-peter-rg`
- **Key Vault**: `stage-peter-kv-101`
- **AKS Cluster**: `stage-peter-cluster`
- **State Key**: `staging.tfstate`

### Production
- **Resource Group**: `prod-peter-rg`
- **Key Vault**: `prod-peter-kv-101`
- **AKS Cluster**: `prod-peter-cluster`
- **State Key**: `production.tfstate`

## 🧩 Modules

### AKS Module
Deploys Azure Kubernetes Service with:
- Managed node pools
- Service Principal authentication
- Network policies
- Monitoring integration

### Key Vault Module
Deploys Azure Key Vault with:
- RBAC authorization
- Purge protection
- Secret management
- Access policies

### Service Principal Module
Creates and manages:
- Azure AD applications
- Service principals
- Password rotation
- Role assignments

## 🔧 Configuration

### Variables
Each environment has its own `terraform.tfvars` file with environment-specific values:

```hcl
rgname                 = "dev-peter-rg"
service_principal_name = "dev-peter-spn"
keyvault_name          = "dev-peter-kv-101"
SUB_ID                 = "your-subscription-id"
cluster_name           = "dev-peter-cluster"
node_pool_name         = "devnp"
```

### Backend Configuration
State is stored in Azure Storage:
- **Storage Account**: `tfdevbackend2025peter`
- **Container**: `tfstate`
- **Resource Group**: `terraform-state-rg`

## 🔒 Security

### Best Practices Implemented
- ✅ Least privilege access
- ✅ Service Principal authentication
- ✅ Key Vault for secrets
- ✅ RBAC authorization
- ✅ Network security groups

### Secrets Management
- GitHub Secrets for CI/CD authentication
- Azure Key Vault for application secrets
- Service Principal rotation support

## 📊 Monitoring

### Resources Created
- Resource Groups
- AKS Clusters with monitoring
- Key Vaults with audit logging
- Service Principals with role assignments

### Health Checks
- AKS cluster health
- Key Vault accessibility
- Service Principal permissions

## 🚨 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Permission denied** | Check Service Principal roles |
| **Backend error** | Verify storage account access |
| **Module not found** | Check module paths in main.tf |
| **Resource conflict** | Check for existing resources |

### Useful Commands

```bash
# Check Terraform version
terraform version

# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Show current state
terraform show

# Import existing resource
terraform import <resource_type>.<name> <azure_resource_id>
```

## 📞 Support

For infrastructure-related issues:
- Check the [main documentation](../README.md)
- Review [GitHub Actions setup](../GITHUB_ACTIONS_SETUP.md)
- Open an issue in the repository

---

**Note**: Always test changes in development environment before promoting to staging or production.
