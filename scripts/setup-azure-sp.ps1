# Azure Service Principal Setup for GitHub Actions (PowerShell)
# Run this script in Azure Cloud Shell (PowerShell) or with Azure PowerShell installed

Write-Host "Setting up Azure Service Principal for GitHub Actions..." -ForegroundColor Green

# Variables - Update these with your values
$SUBSCRIPTION_ID = "your-subscription-id"  # Replace with your Azure subscription ID
$RESOURCE_GROUP = "terraform-state-rg"     # Your existing resource group
$SP_NAME = "github-actions-terraform-sp"   # Service Principal name

# Login to Azure (skip if already logged in)
Write-Host "Logging into Azure..." -ForegroundColor Yellow
Connect-AzAccount

# Set the subscription
Write-Host "Setting subscription to: $SUBSCRIPTION_ID" -ForegroundColor Yellow
Select-AzSubscription -SubscriptionId $SUBSCRIPTION_ID

# Create Service Principal
Write-Host "Creating Service Principal: $SP_NAME" -ForegroundColor Yellow

# Using Azure CLI for Service Principal creation (more reliable for GitHub Actions format)
$SP_OUTPUT = az ad sp create-for-rbac `
  --name $SP_NAME `
  --role Contributor `
  --scopes "/subscriptions/$SUBSCRIPTION_ID" `
  --sdk-auth

Write-Host "Service Principal created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "GITHUB SECRETS CONFIGURATION" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Add the following secrets to your GitHub repository:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. AZURE_CREDENTIALS (entire JSON output below):" -ForegroundColor White
Write-Host $SP_OUTPUT -ForegroundColor Green
Write-Host ""

# Parse JSON to extract individual values
$SP_JSON = $SP_OUTPUT | ConvertFrom-Json
$CLIENT_ID = $SP_JSON.clientId
$CLIENT_SECRET = $SP_JSON.clientSecret
$TENANT_ID = $SP_JSON.tenantId
$SUBSCRIPTION_ID_FROM_JSON = $SP_JSON.subscriptionId

Write-Host "2. Extract and add these individual secrets:" -ForegroundColor White
Write-Host "   AZURE_CLIENT_ID: $CLIENT_ID" -ForegroundColor Green
Write-Host "   AZURE_CLIENT_SECRET: $CLIENT_SECRET" -ForegroundColor Green
Write-Host "   AZURE_TENANT_ID: $TENANT_ID" -ForegroundColor Green
Write-Host "   AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID_FROM_JSON" -ForegroundColor Green
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "ADDITIONAL SETUP REQUIRED" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Grant storage account access:" -ForegroundColor Yellow
Write-Host "az role assignment create \\" -ForegroundColor White
Write-Host "  --assignee $CLIENT_ID \\" -ForegroundColor White
Write-Host "  --role 'Storage Blob Data Contributor' \\" -ForegroundColor White
Write-Host "  --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/tfdevbackend2025peter" -ForegroundColor White
Write-Host ""
Write-Host "4. Grant Key Vault permissions (if using Key Vault):" -ForegroundColor Yellow
Write-Host "az keyvault set-policy \\" -ForegroundColor White
Write-Host "  --name your-keyvault-name \\" -ForegroundColor White
Write-Host "  --spn $CLIENT_ID \\" -ForegroundColor White
Write-Host "  --secret-permissions get list set delete \\" -ForegroundColor White
Write-Host "  --key-permissions get list create delete \\" -ForegroundColor White
Write-Host "  --certificate-permissions get list create delete" -ForegroundColor White
Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
