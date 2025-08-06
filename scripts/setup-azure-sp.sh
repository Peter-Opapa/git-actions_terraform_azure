#!/bin/bash

# Azure Service Principal Setup Script for GitHub Actions
# Run this script in Azure Cloud Shell or with Azure CLI installed

echo "Setting up Azure Service Principal for GitHub Actions..."

# Variables - Update these with your values
SUBSCRIPTION_ID="your-subscription-id"  # Replace with your Azure subscription ID
RESOURCE_GROUP="terraform-state-rg"     # Your existing resource group
SP_NAME="github-actions-terraform-sp"   # Service Principal name

# Login to Azure (skip if already logged in)
echo "Logging into Azure..."
az login

# Set the subscription
echo "Setting subscription to: $SUBSCRIPTION_ID"
az account set --subscription $SUBSCRIPTION_ID

# Create Service Principal
echo "Creating Service Principal: $SP_NAME"
SP_OUTPUT=$(az ad sp create-for-rbac \
  --name $SP_NAME \
  --role Contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID \
  --sdk-auth)

echo "Service Principal created successfully!"
echo ""
echo "================================================"
echo "GITHUB SECRETS CONFIGURATION"
echo "================================================"
echo ""
echo "Add the following secrets to your GitHub repository:"
echo ""
echo "1. AZURE_CREDENTIALS (entire JSON output below):"
echo "$SP_OUTPUT"
echo ""
echo "2. Extract and add these individual secrets from the JSON above:"

# Extract individual values
CLIENT_ID=$(echo $SP_OUTPUT | jq -r '.clientId')
CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r '.clientSecret')
TENANT_ID=$(echo $SP_OUTPUT | jq -r '.tenantId')
SUBSCRIPTION_ID_FROM_JSON=$(echo $SP_OUTPUT | jq -r '.subscriptionId')

echo "   AZURE_CLIENT_ID: $CLIENT_ID"
echo "   AZURE_CLIENT_SECRET: $CLIENT_SECRET"
echo "   AZURE_TENANT_ID: $TENANT_ID"
echo "   AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID_FROM_JSON"
echo ""
echo "================================================"
echo "ADDITIONAL SETUP REQUIRED"
echo "================================================"
echo ""
echo "3. Ensure your Service Principal has access to the storage account:"
echo "   az role assignment create \\"
echo "     --assignee $CLIENT_ID \\"
echo "     --role 'Storage Blob Data Contributor' \\"
echo "     --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/tfdevbackend2025peter"
echo ""
echo "4. Grant Key Vault permissions if using Key Vault:"
echo "   az keyvault set-policy \\"
echo "     --name your-keyvault-name \\"
echo "     --spn $CLIENT_ID \\"
echo "     --secret-permissions get list set delete \\"
echo "     --key-permissions get list create delete \\"
echo "     --certificate-permissions get list create delete"
echo ""
echo "Setup complete!"
