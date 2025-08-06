# Security Policy

## Supported Versions

We support the following versions of this project with security updates:

| Version | Supported          |
| ------- | ------------------ |
| main    | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please follow these steps:

### 🔒 Private Reporting

1. **DO NOT** create a public GitHub issue for security vulnerabilities
2. **DO** email us privately at: [security@yourdomain.com] (replace with actual email)
3. **Include** the following information:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### 📋 What to Include

- **Clear description** of the vulnerability
- **Reproduction steps** with minimal example
- **Impact assessment** (what could an attacker do?)
- **Affected versions** (if known)
- **Your contact information** for follow-up

### ⏱️ Response Timeline

- **24 hours**: We'll acknowledge receipt of your report
- **72 hours**: We'll provide initial assessment
- **7 days**: We'll work on a fix and provide updates
- **30 days**: We'll release a security patch (if confirmed)

### 🛡️ Security Best Practices

When using this project:

#### Terraform Security
- ✅ Never commit `.tfvars` files with sensitive data
- ✅ Use Azure Key Vault for secrets
- ✅ Enable state file encryption
- ✅ Use least privilege access
- ✅ Regular security scans

#### GitHub Actions Security
- ✅ Use environment secrets, not repository secrets for production
- ✅ Enable required reviewers for production deployments
- ✅ Use specific action versions (not @main)
- ✅ Monitor action permissions
- ✅ Regularly rotate Azure Service Principal secrets

#### Azure Security
- ✅ Enable Azure Security Center
- ✅ Use managed identities when possible
- ✅ Regular access reviews
- ✅ Enable audit logging
- ✅ Use network security groups

### 🚨 Common Security Issues

| Issue | Risk Level | Mitigation |
|-------|------------|------------|
| Hardcoded secrets | High | Use Azure Key Vault / GitHub Secrets |
| Public state files | High | Use private storage with encryption |
| Overprivileged SPs | Medium | Apply least privilege principle |
| Unmonitored deployments | Medium | Enable logging and monitoring |
| Outdated dependencies | Low-Medium | Regular updates and scans |

### 📞 Contact Information

- **Security Email**: [Replace with actual security contact]
- **Maintainer**: [Peter-Opapa](https://github.com/Peter-Opapa)
- **Project Issues**: [GitHub Issues](https://github.com/Peter-Opapa/Terraform-Azure/issues)

### 🏆 Acknowledgments

We appreciate responsible disclosure and will acknowledge security researchers who help improve our security posture.

---

**Thank you for helping keep our project secure!** 🔒
