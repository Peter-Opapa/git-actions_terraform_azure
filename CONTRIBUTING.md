# Contributing to Terraform-Azure Project

Thank you for your interest in contributing to this project! This guide will help you get started.

## 🚀 Quick Start for Contributors

### Prerequisites
- Azure subscription
- GitHub account
- Basic knowledge of Terraform and Azure
- Familiarity with Git workflows

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Peter-Opapa/Terraform-Azure.git
   cd Terraform-Azure
   ```

2. **Install dependencies**
   - [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.7
   - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - [VS Code](https://code.visualstudio.com/) (recommended)

3. **Configure Azure authentication**
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

## 📁 Project Structure

```
├── .github/workflows/          # CI/CD workflows
├── scripts/                    # Setup and utility scripts
├── lessons/day26/              # Main Terraform code
│   ├── dev/                    # Development environment
│   ├── staging/                # Staging environment
│   └── modules/                # Reusable modules
├── docs/                       # Documentation
└── README.md
```

## 🔄 Development Workflow

### Making Changes

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow Terraform best practices
   - Add comments for complex logic
   - Update documentation if needed

3. **Test locally**
   ```bash
   cd lessons/day26/dev
   terraform init
   terraform plan
   ```

4. **Commit and push**
   ```bash
   git add .
   git commit -m "feat: description of your changes"
   git push origin feature/your-feature-name
   ```

5. **Create Pull Request**
   - Use descriptive title and description
   - Link to any related issues
   - Ensure CI checks pass

### Pull Request Guidelines

- ✅ **Clear description** of changes
- ✅ **Test results** included
- ✅ **Documentation** updated
- ✅ **No sensitive data** in commits
- ✅ **Follows** coding standards

## 🧪 Testing

### Automated Testing
- GitHub Actions run on every PR
- Terraform validation and planning
- Security scanning

### Manual Testing
```bash
# Validate Terraform
terraform validate

# Check formatting
terraform fmt -check

# Plan changes
terraform plan
```

## 📋 Coding Standards

### Terraform Standards
- Use consistent naming conventions
- Add descriptions to variables
- Use modules for reusable components
- Follow security best practices

### Example:
```hcl
variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty."
  }
}
```

## 🐛 Reporting Issues

When reporting issues, please include:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Error messages and logs
- Your environment details

## 📞 Getting Help

- 📖 Check the [documentation](./GITHUB_ACTIONS_SETUP.md)
- 🐛 Search existing [issues](https://github.com/Peter-Opapa/Terraform-Azure/issues)
- 💬 Join discussions in the repository
- 📧 Contact maintainers for urgent issues

## 🙏 Thank You

Your contributions help make this project better for everyone. Whether it's code, documentation, or feedback, every contribution is valued!

---

**Happy coding! 🚀**
