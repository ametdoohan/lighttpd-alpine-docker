# Container Security

This repository implements automated vulnerability scanning to ensure the security of the Docker container using **free GitHub features** that work without GitHub Enterprise or Advanced Security.

## Security Scanning

The project uses [Trivy](https://trivy.dev/) for vulnerability scanning, which is integrated into the CI/CD pipeline via GitHub Actions and provides results through multiple channels.

### Automated Scans (Free Edition Compatible)

- **Pull Request Scans**: Every pull request is automatically scanned with results posted as comments
- **Push Scans**: Main branch pushes trigger security scans with artifacts
- **Scheduled Scans**: Weekly security scans run on Sundays at midnight UTC
- **Workflow Artifacts**: Scan results are stored as downloadable artifacts (30-day retention)
- **PR Comments**: Vulnerability summaries are automatically posted on pull requests

### Available Workflows

1. **container-scan-free.yml**: Free GitHub edition compatible workflow
   - Works without GitHub Enterprise or Advanced Security
   - Provides scan results via artifacts and PR comments
   - Includes vulnerability count summaries
   
2. **security-scan.yml**: Legacy workflow (requires GitHub Advanced Security)
   - Uses SARIF upload to Security tab (Enterprise feature)
   - May not work on free GitHub accounts

### Security Policies

- **Critical/High Severity**: Builds fail if critical or high severity vulnerabilities are found
- **Medium/Low Severity**: Reported but don't block builds
- **Artifact Storage**: All scan results stored as workflow artifacts for 30 days
- **PR Integration**: Automatic vulnerability summaries in pull request comments

### Manual Scanning

#### Quick Start with Provided Script

```bash
# Make script executable (if needed)
chmod +x scripts/container-scan.sh

# Run scan with automatic Trivy installation
./scripts/container-scan.sh --install-trivy

# Run scan on existing image
./scripts/container-scan.sh --no-build -i your-image:tag

# Get help
./scripts/container-scan.sh --help
```

#### Manual Trivy Installation and Scanning

```bash
# Build the image
docker build -t lighttpd-alpine:test .

# Install Trivy (if not already installed)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan the image
trivy image lighttpd-alpine:test

# Generate different output formats
trivy image --format json --output results.json lighttpd-alpine:test
trivy image --format table lighttpd-alpine:test
```

### Security Best Practices

- **Updated Base Image**: Uses Alpine 3.19 (updated from 3.12.0) to reduce known vulnerabilities
- Regular base image updates
- Minimal attack surface (Alpine Linux)
- Non-root user execution
- Regular dependency scanning
- Automated security monitoring