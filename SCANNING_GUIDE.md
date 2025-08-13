# Container Scanning Usage Guide

This guide explains how to access and use container vulnerability scan results with the free GitHub edition.

## How Container Scanning Works (Free Edition)

### 1. Automated Scanning
The `container-scan-free.yml` workflow runs automatically:
- **On Pull Requests**: Scans your changes and posts results as comments
- **On Main Branch Pushes**: Scans the latest code
- **Weekly Schedule**: Runs every Sunday at midnight UTC

### 2. Viewing Scan Results

#### Option 1: Pull Request Comments
When you create a PR, you'll see an automated comment with a summary like:
```
## Container Vulnerability Scan Results

| Severity | Count |
|----------|-------|
| Critical | 0     |
| High     | 2     |
| Medium   | 5     |
| Low      | 10    |

❌ **Security scan failed**: Found 0 critical and 2 high severity vulnerabilities

📋 Full scan results are available as workflow artifacts.
```

#### Option 2: Workflow Artifacts
1. Go to the **Actions** tab in your GitHub repository
2. Click on the latest "Container Security Scan (Free Edition)" workflow run
3. Scroll down to the **Artifacts** section
4. Download `trivy-scan-results-<run-id>` ZIP file
5. Extract to find:
   - `trivy-results.json`: Detailed scan results in JSON format
   - `scan-summary.md`: Human-readable summary

#### Option 3: Workflow Logs
1. Go to the **Actions** tab in your GitHub repository
2. Click on a workflow run
3. Expand the "Run Trivy vulnerability scanner (table format for logs)" step
4. View the table format results directly in the logs

### 3. Local Scanning

#### Quick Method (Recommended)
```bash
# Run the provided script with auto-installation
./scripts/container-scan.sh --install-trivy

# Results will be saved in ./scan-results/ directory
```

#### Manual Method
```bash
# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Build your image
docker build -t lighttpd-alpine:test .

# Scan the image
trivy image lighttpd-alpine:test

# Generate JSON report
trivy image --format json --output scan-results.json lighttpd-alpine:test
```

## Understanding Results

### Severity Levels
- **Critical**: Immediate attention required, may allow system compromise
- **High**: Should be addressed quickly, significant security risk
- **Medium**: Should be addressed in reasonable timeframe
- **Low**: Low risk, can be addressed during regular maintenance

### Build Status
- ✅ **Pass**: No critical or high severity vulnerabilities
- ❌ **Fail**: Critical or high severity vulnerabilities found (blocks deployment)

### Report Formats
- **Table**: Easy to read in terminal/logs
- **JSON**: Machine readable, contains detailed information
- **Summary**: Quick overview with vulnerability counts

## Troubleshooting

### "Trivy not found" Error
```bash
# Install Trivy manually
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

### "Permission denied" on Script
```bash
# Make script executable
chmod +x scripts/container-scan.sh
```

### No Scan Results in PR
- Check that the workflow completed successfully in the Actions tab
- Ensure the PR is targeting main/master branch
- Verify the workflow has proper permissions

### Cannot Access GitHub Security Tab
This is expected with free GitHub accounts. The Security tab requires GitHub Advanced Security (Enterprise feature). This solution provides equivalent functionality through:
- PR comments
- Workflow artifacts  
- Workflow logs
- Local scanning script

## Best Practices

1. **Review scan results** before merging PRs
2. **Address critical and high severity** vulnerabilities promptly  
3. **Run local scans** during development to catch issues early
4. **Keep base images updated** to reduce vulnerabilities
5. **Monitor weekly scans** to catch new vulnerabilities in existing deployments

## Getting Help

- Check the workflow logs in the Actions tab
- Review the detailed JSON reports in artifacts
- Use the local scanning script for debugging
- Refer to [Trivy documentation](https://aquasecurity.github.io/trivy/) for advanced usage