# GitHub Secrets Troubleshooting Guide

## ✅ **Required GitHub Secrets Format**

In your GitHub repository → Settings → Secrets and variables → Actions, you need exactly these 5 secrets:

### 1. AZURE_CLIENT_ID
- **Value**: Your Service Principal Application (client) ID
- **Format**: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (UUID format)
- **Example**: `12345678-1234-1234-1234-123456789012`

### 2. AZURE_CLIENT_SECRET  
- **Value**: Your Service Principal client secret value
- **Format**: Plain text secret (usually starts with special characters)
- **Example**: `~abcdefg123456789HIJKLMNOP._qrstuvwxyz`

### 3. AZURE_TENANT_ID
- **Value**: Your Azure AD tenant ID  
- **Format**: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (UUID format)
- **Example**: `87654321-4321-4321-4321-210987654321`

### 4. AZURE_SUBSCRIPTION_ID
- **Value**: Your Azure subscription ID
- **Format**: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx (UUID format)  
- **Example**: `11111111-2222-3333-4444-555555555555`

### 5. AZURE_BACKEND_STORAGE_ACCOUNT
- **Value**: Your Terraform backend storage account name
- **Format**: Plain text storage account name (lowercase, no special characters)
- **Example**: `tfdevbackend2025peter`

## 🔍 **How to Get These Values**

### Option 1: From Service Principal Creation Output
When you created the Service Principal, you should have received JSON output like:
```json
{
  "clientId": "12345678-1234-1234-1234-123456789012",
  "clientSecret": "~abcdefg123456789HIJKLMNOP._qrstuvwxyz", 
  "subscriptionId": "11111111-2222-3333-4444-555555555555",
  "tenantId": "87654321-4321-4321-4321-210987654321"
}
```

### Option 2: Using Azure CLI Commands
```bash
# Get your subscription and tenant info
az account show --output table

# Get your Service Principal info (replace SP_NAME with your SP name)
az ad sp list --display-name "github-actions-terraform-sp" --output table
```

## 🚨 **Common Issues & Solutions**

### Issue: "Not all values are present"
- **Solution**: Check that all 5 secrets are added to GitHub with exact names above
- **Check**: Secret names are case-sensitive and must match exactly

### Issue: "Authentication failed"  
- **Solution**: Verify the client secret is correct and hasn't expired
- **Check**: Service Principal has correct permissions on your subscription

### Issue: "Invalid client secret"
- **Solution**: Recreate the Service Principal client secret
- **Command**: `az ad sp credential reset --id YOUR_CLIENT_ID`

## 🎯 **Testing Your Secrets**

Run this locally to test your credentials:
```bash
az login --service-principal \
  --username YOUR_CLIENT_ID \
  --password YOUR_CLIENT_SECRET \
  --tenant YOUR_TENANT_ID

az account show
```

If this works locally, then your GitHub secrets should work too.
