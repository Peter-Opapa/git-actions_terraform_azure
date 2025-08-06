#!/bin/bash

# Fresh Repository Setup Script
# This script helps you create a completely new repository without inheriting git history

echo "🚀 Setting up fresh Azure Infrastructure Deployment Platform repository..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Removing existing git history...${NC}"
if [ -d ".git" ]; then
    rm -rf .git
    echo -e "${GREEN}✅ Removed existing git history${NC}"
else
    echo -e "${YELLOW}⚠️ No existing git history found${NC}"
fi

echo -e "${BLUE}Step 2: Initializing new git repository...${NC}"
git init
git add .
git commit -m "feat: Initial commit - Azure Infrastructure Deployment Platform

🚀 Enterprise-grade Azure infrastructure automation platform
✨ Production-ready AKS clusters with GitHub Actions CI/CD
🔐 Secure multi-environment deployment workflows
🛠️ Terraform modules for AKS, Key Vault, and Service Principals

This is a complete infrastructure deployment platform built from scratch."

echo -e "${GREEN}✅ Created fresh git repository with clean history${NC}"

echo -e "${BLUE}Step 3: Repository setup complete!${NC}"
echo -e "${GREEN}Your repository now has a clean history with only your commit.${NC}"

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Create a new repository on GitHub"
echo "2. Add the remote: git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git"
echo "3. Push to GitHub: git push -u origin main"
echo "4. Add GitHub secrets following GITHUB_ACTIONS_SETUP.md"
echo ""
echo -e "${GREEN}🎉 Your fresh Azure Infrastructure Deployment Platform is ready!${NC}"
