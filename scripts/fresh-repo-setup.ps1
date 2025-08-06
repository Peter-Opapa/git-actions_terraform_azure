# Fresh Repository Setup Script for PowerShell
# This script helps you create a completely new repository without inheriting git history

Write-Host "🚀 Setting up fresh Azure Infrastructure Deployment Platform repository..." -ForegroundColor Blue

Write-Host "Step 1: Removing existing git history..." -ForegroundColor Blue
if (Test-Path ".git") {
    Remove-Item -Recurse -Force ".git"
    Write-Host "✅ Removed existing git history" -ForegroundColor Green
} else {
    Write-Host "⚠️ No existing git history found" -ForegroundColor Yellow
}

Write-Host "Step 2: Initializing new git repository..." -ForegroundColor Blue
git init
git add .
git commit -m "feat: Initial commit - Azure Infrastructure Deployment Platform

🚀 Enterprise-grade Azure infrastructure automation platform
✨ Production-ready AKS clusters with GitHub Actions CI/CD
🔐 Secure multi-environment deployment workflows
🛠️ Terraform modules for AKS, Key Vault, and Service Principals

This is a complete infrastructure deployment platform built from scratch."

Write-Host "✅ Created fresh git repository with clean history" -ForegroundColor Green

Write-Host "Step 3: Repository setup complete!" -ForegroundColor Blue
Write-Host "Your repository now has a clean history with only your commit." -ForegroundColor Green

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Create a new repository on GitHub"
Write-Host "2. Add the remote: git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git"
Write-Host "3. Push to GitHub: git push -u origin main"
Write-Host "4. Add GitHub secrets following GITHUB_ACTIONS_SETUP.md"
Write-Host ""
Write-Host "🎉 Your fresh Azure Infrastructure Deployment Platform is ready!" -ForegroundColor Green
