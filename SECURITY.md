# Container Security

This repository implements automated vulnerability scanning to ensure the security of the Docker container.

## Security Scanning

The project uses [Trivy](https://trivy.dev/) for vulnerability scanning, which is integrated into the CI/CD pipeline via GitHub Actions.

### Automated Scans

- **Pull Request Scans**: Every pull request is automatically scanned for vulnerabilities
- **Push Scans**: Main branch pushes trigger security scans
- **Scheduled Scans**: Weekly security scans run on Sundays at midnight UTC
- **Security Reports**: Scan results are uploaded to GitHub Security tab

### Security Policies

- **Critical/High Severity**: Builds fail if critical or high severity vulnerabilities are found
- **Medium/Low Severity**: Reported but don't block builds
- **SARIF Format**: Security results are uploaded in SARIF format for GitHub Security integration

### Manual Scanning

To run vulnerability scans locally:

```bash
# Build the image
docker build -t lighttpd-alpine:test .

# Install Trivy (if not already installed)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan the image
trivy image lighttpd-alpine:test
```

### Security Best Practices

- **Updated Base Image**: Uses Alpine 3.19 (updated from 3.12.0) to reduce known vulnerabilities
- Regular base image updates
- Minimal attack surface (Alpine Linux)
- Non-root user execution
- Regular dependency scanning
- Automated security monitoring