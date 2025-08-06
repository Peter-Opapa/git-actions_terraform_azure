# GitHub Actions Setup Guide for Terraform Azure Deployment

This guide will help you set up GitHub Actions to deploy your Terraform infrastructure to Azure.

## Prerequisites

1. Azure subscription with appropriate permissions
2. GitHub repository
3. Terraform backend storage account already created (which you have)

## Step 1: Create Azure Service Principal

### Option A: Using Azure CLI (Recommended)

1. Open Azure Cloud Shell or install Azure CLI locally
2. Run the setup script:
   ```bash
   # Update the subscription ID in the script first
   chmod +x scripts/setup-azure-sp.sh
   ./scripts/setup-azure-sp.sh
   ```

### Option B: Manual Creation

```bash
# Replace with your values
SUBSCRIPTION_ID="your-azure-subscription-id"
SP_NAME="github-actions-terraform-sp"

# Create Service Principal
az ad sp create-for-rbac \
  --name $SP_NAME \
  --role Contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth
```

## Step 2: Required GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions, and add these secrets:

### Required Secrets:

1. **AZURE_CREDENTIALS** - The complete JSON output from the Service Principal creation
   ```json
   {
     "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "clientSecret": "your-client-secret",
     "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   }
   ```

2. **AZURE_CLIENT_ID** - The clientId from the JSON above
3. **AZURE_CLIENT_SECRET** - The clientSecret from the JSON above  
4. **AZURE_TENANT_ID** - The tenantId from the JSON above
5. **AZURE_SUBSCRIPTION_ID** - The subscriptionId from the JSON above

## Step 3: Configure GitHub Environments

1. Go to your repository → Settings → Environments
2. Create the following environments:
   - `dev`
   - `staging` 
   - `dev-destroy`
   - `staging-destroy`

3. For each environment, you can add:
   - Required reviewers (recommended for production)
   - Environment secrets (if different per environment)
   - Deployment protection rules

## Step 4: Update Terraform Backend Configuration

Your backend configuration in `lessons/day26/dev/backend.tf` and `lessons/day26/staging/backend.tf` should look like this:

```hcl
terraform {
  backend "azurerm" {
    # These will be provided via GitHub Actions
    # resource_group_name  = "terraform-state-rg"
    # storage_account_name = "tfdevbackend2025peter"  
    # container_name      = "tfstate"
    # key                 = "dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}
```

## Step 5: Additional Azure Permissions

Grant the Service Principal additional permissions:

### Storage Account Access (Required):
```bash
az role assignment create \
  --assignee <CLIENT_ID> \
  --role "Storage Blob Data Contributor" \
  --scope /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/terraform-state-rg/providers/Microsoft.Storage/storageAccounts/tfdevbackend2025peter
```

### Key Vault Access (Required for your configuration):
```bash
# Note: Key Vault will be created by Terraform in YOUR application resource group, not the backend RG
# This command should be run AFTER first deployment or use the resource group scope version below
az keyvault set-policy \
  --name <your-keyvault-name> \
  --spn <CLIENT_ID> \
  --secret-permissions get list set delete \
  --key-permissions get list create delete \
  --certificate-permissions get list create delete
```

**Alternative (Recommended): Grant access to the entire resource group:**
```bash
# This works immediately and covers the Key Vault when it's created
az role assignment create \
  --assignee <CLIENT_ID> \
  --role "Key Vault Administrator" \
  --scope /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/dev-peter-rg
```

**Important:** Your Key Vault will be created in the **application resource group** (`dev-peter-rg`), NOT the backend storage resource group (`terraform-state-rg`).

## Understanding the Secret Flow

**You have TWO different Service Principals:**

### 1. GitHub Actions Service Principal (CI/CD)
- **Purpose**: GitHub Actions authenticates to Azure
- **Secrets stored**: GitHub repository secrets
- **Used by**: GitHub Actions workflow only
- **Created**: Manually (you already did this)

### 2. Application Service Principal (Your Apps)
- **Purpose**: Your deployed applications (AKS, etc.) authenticate to Azure
- **Secrets stored**: Azure Key Vault  
- **Used by**: Your applications and AKS cluster
- **Created**: Automatically by Terraform

### Secret Flow Diagram:
```
GitHub Secrets → GitHub Actions → Terraform → Creates New SP → Stores in Key Vault → Used by Apps
```

### How Terraform Gets Secrets to Key Vault:

Looking at your `main.tf`, here's what happens:

1. **GitHub Actions** uses GitHub secrets to authenticate to Azure
2. **Terraform runs** and creates a NEW Service Principal via the `ServicePrincipal` module
3. **Terraform stores** the NEW Service Principal's credentials in Key Vault:
   ```hcl
   resource "azurerm_key_vault_secret" "example" {
     name         = module.ServicePrincipal.client_id
     value        = module.ServicePrincipal.client_secret  # ← NEW SP secret
     key_vault_id = module.keyvault.keyvault_id
   }
   ```
4. **Your AKS cluster** uses the NEW Service Principal credentials (from Key Vault)

### Why This Architecture:

| Component | Service Principal | Secret Storage | Purpose |
|-----------|------------------|----------------|---------|
| **GitHub Actions** | GitHub Actions SP | GitHub Secrets | Deploy infrastructure |
| **AKS Cluster** | Application SP | Key Vault | Run workloads |

This separation provides:
- ✅ **Security**: CI/CD credentials separate from application credentials
- ✅ **Rotation**: Can rotate app secrets without affecting CI/CD
- ✅ **Least privilege**: Each SP has only needed permissions

### Practical Example from Your Code:

1. **GitHub Actions SP** authenticates using `AZURE_CREDENTIALS` from GitHub secrets
2. **Terraform runs** and creates:
   ```hcl
   # Creates NEW Service Principal for applications
   module "ServicePrincipal" {
     source = "../modules/ServicePrincipal"
     service_principal_name = var.service_principal_name
   }
   
   # Stores NEW SP credentials in Key Vault
   resource "azurerm_key_vault_secret" "example" {
     name         = module.ServicePrincipal.client_id
     value        = module.ServicePrincipal.client_secret  # ← Generated by Terraform
     key_vault_id = module.keyvault.keyvault_id
   }
   
   # AKS uses the NEW Service Principal (not GitHub Actions SP)
   module "aks" {
     client_id     = module.ServicePrincipal.client_id
     client_secret = module.ServicePrincipal.client_secret
   }
   ```

3. **Result**: Your AKS cluster uses the application SP credentials, which are stored in Key Vault for other services to access.

## What Terraform Will Create Automatically

**Yes, Terraform will create everything automatically without your intervention!**

### Resources Created by Your Terraform:

Based on your configuration, when you run the GitHub Actions workflow, Terraform will automatically create:

1. **Application Resource Group**: `dev-peter-rg` (your main application resources)
2. **Application Service Principal**: `dev-peter-spn` (for your applications)
3. **Key Vault**: `dev-peter-kv-101` (in the application resource group, NOT backend RG)
4. **Key Vault Secret**: Stores the application Service Principal credentials
5. **AKS Cluster**: `dev-peter-cluster` with node pool `devnp`
6. **Role Assignments**: Grants the application SP access to your subscription
7. **Kubeconfig File**: Saved locally for kubectl access

### Resource Group Separation:

| Resource Group | Purpose | Contains |
|----------------|---------|----------|
| **`terraform-state-rg`** | Backend storage | Storage Account (`tfdevbackend2025peter`) |
| **`dev-peter-rg`** | Your applications | Key Vault, AKS, Service Principals |

### What You Need to Do vs. What's Automatic:

| Task | Manual | Automatic |
|------|--------|-----------|
| Create GitHub Actions SP | ✅ Manual | |
| Add GitHub Secrets | ✅ Manual | |
| Create backend storage account | ✅ Already done | |
| Grant storage permissions | ✅ Manual | |
| Grant Key Vault permissions | ✅ Manual (pre-deployment) | |
| Create application resource group | | ✅ Terraform |
| Create Key Vault | | ✅ Terraform |
| Create application Service Principal | | ✅ Terraform |
| Store secrets in Key Vault | | ✅ Terraform |
| Create AKS cluster | | ✅ Terraform |
| Configure AKS authentication | | ✅ Terraform |

## Step 6: Workflow Triggers

The GitHub Actions workflows will trigger on:

### Terraform Deploy (`terraform-deploy.yml`):
- **Push to main**: Automatically applies to dev environment
- **Pull Request**: Runs validation and plan
- **Manual trigger**: Choose dev or staging environment

### Terraform Destroy (`terraform-destroy.yml`):
- **Manual trigger only**: Choose environment and confirm with "destroy"

## Step 7: Testing the Setup

1. **Test validation**: Create a pull request with a small change
2. **Test dev deployment**: Push to main branch
3. **Test manual deployment**: Use "Run workflow" button in GitHub Actions

## Step 8: Monitoring and Troubleshooting

### Common Issues:

1. **Permission errors**: Ensure Service Principal has Contributor role
2. **Backend errors**: Verify storage account access and backend configuration
3. **Variable errors**: Check that all required variables are set in `terraform.tfvars`

### Monitoring:
- GitHub Actions logs show detailed output
- Azure Activity Log shows resource creation/changes
- Terraform state is stored in your Azure Storage Account

## Security Best Practices

1. **Use environment protection rules** for staging/production
2. **Enable branch protection** on main branch
3. **Require pull request reviews** for infrastructure changes
4. **Use least privilege** for Service Principal permissions
5. **Rotate secrets** regularly
6. **Monitor Azure Activity Log** for unauthorized changes

## Next Steps

### 🚀 Ready to Deploy? Follow These Steps:

1. **✅ GitHub Secrets Already Added** (You've completed this!)

2. **🔧 Set up Azure Permissions** (Required before first deployment):
   ```bash
   # Run these commands in Azure Cloud Shell
   
   # Storage Account Access
   az role assignment create \
     --assignee <your-github-actions-client-id> \
     --role "Storage Blob Data Contributor" \
     --scope /subscriptions/<subscription-id>/resourceGroups/terraform-state-rg/providers/Microsoft.Storage/storageAccounts/tfdevbackend2025peter
   
   # Resource Group Access (for Key Vault)
   az role assignment create \
     --assignee <your-github-actions-client-id> \
     --role "Key Vault Administrator" \
     --scope /subscriptions/<subscription-id>/resourceGroups/dev-peter-rg
   ```

3. **🧪 Test the Setup**:
   - Create a small change in `lessons/day26/dev/main.tf`
   - Create a pull request to test validation
   - Merge to main branch to test deployment

4. **🔒 Optional: Configure Environment Protection** (Recommended):
   - Go to repository Settings → Environments
   - Add required reviewers for staging environment
   - Set up deployment protection rules

5. **📊 Monitor Deployments**:
   - Check GitHub Actions tab for workflow status
   - Monitor Azure portal for resource creation
   - Review logs for any issues

### 🎯 Quick Test Commands:

```bash
# Add a comment to trigger workflow
echo "# Updated $(date)" >> lessons/day26/dev/main.tf
git add . && git commit -m "test: trigger GitHub Actions workflow"
git push origin main
```

---

## 🆘 Troubleshooting

### Common Issues:

| Error | Solution |
|-------|----------|
| **Permission denied** | Check Service Principal has Contributor role |
| **Storage backend error** | Verify storage account access permissions |
| **Key Vault access denied** | Grant Key Vault Administrator role |
| **Terraform validation failed** | Check syntax in `.tf` files |
| **Resource already exists** | Check if resources exist in Azure portal |

### Get Help:
- 📖 Check [Contributing Guide](./CONTRIBUTING.md)
- 🐛 Open an [issue](https://github.com/Peter-Opapa/Terraform-Azure/issues)
- 📧 Contact: [Peter-Opapa](https://github.com/Peter-Opapa)

---

**🎉 You're all set! Happy deploying with GitHub Actions!** 🚀
