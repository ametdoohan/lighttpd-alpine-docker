# Container Scanning Usage Guide (Enhanced PR Integration)

This guide explains how to access and use container vulnerability scan results with the enhanced free GitHub edition that provides rich pull request integration.

## How Enhanced Container Scanning Works

### 1. Automated Scanning with PR Integration
The enhanced `container-scan-free.yml` workflow provides comprehensive PR integration:
- **On Pull Requests**: 
  - Sets initial "pending" status check
  - Scans container and posts rich formatted results as comments
  - Updates status checks with scan results (success/failure/warning)
  - Automatically labels PR based on vulnerability severity
  - Provides remediation guidance and next steps
- **On Main Branch Pushes**: Scans the latest code for monitoring
- **Weekly Schedule**: Runs every Sunday at midnight UTC for continuous monitoring

### 2. Enhanced PR Experience

#### Status Checks Integration 🔄
- **Real-time status**: See scan progress directly in the PR interface
- **Clear indicators**: Success ✅, Warning ⚠️, or Failure ❌ status
- **Direct links**: Click status to view detailed workflow results

#### Automatic PR Labels 🏷️
PRs are automatically labeled based on scan results:
- 🟢 `security-clean` - No security vulnerabilities detected
- 🟡 `security-review` - Medium severity vulnerabilities (review recommended)
- 🔴 `security-risk` - Critical or high severity vulnerabilities found
- 🟣 `security-error` - Security scan failed (needs investigation)

#### Enhanced PR Comments 💬
Rich formatted comments include:
- **Visual vulnerability summary** with emojis and severity indicators
- **Scanner metadata** (version, scan date, image details)
- **Actionable guidance** for resolving vulnerabilities
- **Collapsible remediation section** with step-by-step instructions
- **Direct links** to artifacts, logs, and documentation

### 2. Viewing Enhanced Scan Results

#### Option 1: PR Status Checks and Labels (NEW! ✨)
- **Status Checks**: View scan status directly in the PR interface near the merge button
- **Labels**: Check PR labels for quick vulnerability assessment
- **Real-time Updates**: Status updates as the scan progresses

#### Option 2: Enhanced PR Comments (IMPROVED! 🎨)
When you create a PR, you'll see a rich formatted comment with:
```
## 🔒 Container Vulnerability Scan Results

📦 Image: `lighttpd-alpine:test`
🔍 Scanner: Trivy v0.45.0
📅 Scan Date: 2024-01-15 10:30:00 UTC

### 📊 Vulnerability Summary

| Severity | Count | Status |
|----------|-------|--------|
| 🔴 Critical | 0 | ✅ Clean |
| 🟠 High | 2 | ⚠️ Action Required |
| 🟡 Medium | 5 | ⚡ Review Recommended |
| 🔵 Low | 10 | ℹ️ Informational |

### ⚠️ Security Scan Passed with Warnings

No critical or high severity vulnerabilities found! ✅

However, 5 medium severity vulnerabilities were detected...
```

#### Option 3: Workflow Artifacts (Enhanced! 📦)
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