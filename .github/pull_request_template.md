## 📋 Pull Request Description

<!-- Provide a brief description of the changes in this PR -->

## 🔄 Type of Change

<!-- Please delete options that are not relevant -->

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🔧 Configuration change
- [ ] 🔒 Security improvement

## 🔒 Security Considerations

<!-- This section will be automatically populated by the container security scan -->

- [ ] I have reviewed the automated container security scan results
- [ ] Any critical or high severity vulnerabilities have been addressed
- [ ] I understand that PRs with security issues may not be merged

> **Note:** The automated security scan will run when this PR is created and will post results as a comment below. Please review the results before requesting a merge.

## 🧪 Testing

<!-- Describe the tests you ran to verify your changes -->

- [ ] I have tested the Docker container builds successfully
- [ ] I have run the local security scan: `./scripts/container-scan.sh --install-trivy`
- [ ] The container runs as expected: `docker run -d -p 8080:80 lighttpd-alpine:test`

## 📝 Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have made corresponding changes to the documentation (if applicable)
- [ ] My changes generate no new warnings
- [ ] Any dependent changes have been merged and published

## 🔗 Related Issues

<!-- Link any related issues here -->
Closes #(issue_number)

---

> 🤖 **Automated Security Scanning**: This PR will be automatically scanned for container vulnerabilities. Results will appear in the comments below once the scan completes.