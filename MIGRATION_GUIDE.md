# Migration Guide: From GitHub Enterprise to Free Edition Container Scanning

This guide helps you migrate from GitHub Enterprise Advanced Security features to a free-tier compatible container scanning solution.

## Problem Description

The original `security-scan.yml` workflow used GitHub Advanced Security features that require:
- GitHub Enterprise license
- GitHub Pro/Team for private repositories
- Advanced Security subscription

Specifically, this line causes issues on free accounts:
```yaml
- name: Upload Trivy scan results to GitHub Security tab
  uses: github/codeql-action/upload-sarif@v3  # Requires Advanced Security
```

## Solution Overview

The new `container-scan-free.yml` workflow provides equivalent functionality using only free GitHub features:

### What Changed
| Feature | Enterprise Version | Free Edition Version |
|---------|-------------------|---------------------|
| Vulnerability scanning | ✅ Trivy | ✅ Trivy (same) |
| SARIF upload to Security tab | ✅ Yes (Enterprise required) | ❌ Not available |
| PR comment reports | ❌ No | ✅ Yes |
| Workflow artifacts | ❌ No | ✅ Yes (30-day retention) |
| Build failure on vulnerabilities | ✅ Yes | ✅ Yes (same) |
| Multiple report formats | ✅ Limited | ✅ JSON, Table, Summary |
| Local scanning script | ❌ No | ✅ Yes |

### What You Gain
- **PR Comments**: Automatic vulnerability summaries posted on pull requests
- **Workflow Artifacts**: Downloadable scan results with detailed information
- **Better Documentation**: Comprehensive guides and examples
- **Local Scanning**: Script for running scans during development
- **No License Required**: Works on all GitHub account types

## Migration Steps

### Step 1: Replace Workflow File
Choose one of these approaches:

#### Option A: Replace the existing workflow
```bash
# Rename the old workflow (to keep as backup)
mv .github/workflows/security-scan.yml .github/workflows/security-scan.yml.backup

# Rename the new workflow to replace it
mv .github/workflows/container-scan-free.yml .github/workflows/security-scan.yml
```

#### Option B: Use both workflows (recommended)
Keep both workflows active. The free edition workflow will provide immediate value while you maintain the enterprise one for environments that support it.

### Step 2: Update Badge URLs
Update your README.md badges:

**Before:**
```markdown
[![Container Security](https://github.com/username/repo/actions/workflows/security-scan.yml/badge.svg)](https://github.com/username/repo/actions/workflows/security-scan.yml)
```

**After:**
```markdown
[![Container Security](https://github.com/username/repo/actions/workflows/container-scan-free.yml/badge.svg)](https://github.com/username/repo/actions/workflows/container-scan-free.yml)
```

### Step 3: Update Documentation
- Add the new scanning guide to your documentation
- Update security policies to reflect the new artifact-based approach
- Include local scanning instructions for developers

### Step 4: Test the New Workflow
1. Create a test pull request
2. Verify the workflow runs successfully
3. Check that PR comments are posted with scan results
4. Download and review the workflow artifacts

## Accessing Scan Results

### Previous Method (Enterprise)
- Results appeared in the **Security** tab
- SARIF format integrated with GitHub's security features
- Required Advanced Security license

### New Method (Free Edition)
- **PR Comments**: Vulnerability summaries automatically posted
- **Workflow Artifacts**: Download detailed results from Actions tab
- **Workflow Logs**: View table format results in action logs
- **Local Scanning**: Run scans during development with provided script

## Troubleshooting Migration Issues

### Workflow Permission Errors
Ensure your workflow has the necessary permissions:
```yaml
permissions:
  contents: read
  issues: write
  pull-requests: write
```

### No PR Comments Appearing
1. Check that the workflow completed successfully
2. Verify repository permissions allow Actions to comment
3. Ensure the PR targets the correct branch (main/master)

### Cannot Access Security Tab
This is expected with free GitHub accounts. The new solution provides equivalent functionality through:
- Detailed artifacts with JSON reports
- PR comments with summaries
- Workflow logs with table format results

### Artifacts Not Available
Artifacts are retained for 30 days by default. If you need longer retention:
1. Download important scan results
2. Store them in your own systems
3. Consider upgrading to a paid plan for longer artifact retention

## Best Practices for Free Edition

1. **Review PR Comments**: Always check vulnerability summaries before merging
2. **Download Critical Results**: Save important scan results before artifact expiration
3. **Use Local Scanning**: Run scans during development to catch issues early
4. **Monitor Weekly Scans**: Check scheduled scan results regularly
5. **Address High-Severity Issues**: Prioritize critical and high severity vulnerabilities

## Advanced Configuration

### Custom Severity Levels
Modify the workflow to scan for different severity levels:
```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'your-image:tag'
    format: 'json'
    output: 'trivy-results.json'
    severity: 'CRITICAL,HIGH'  # Only scan for critical and high
```

### Custom Failure Conditions
Adjust when builds should fail:
```yaml
- name: Fail build on vulnerabilities
  if: steps.parse-results.outputs.CRITICAL_COUNT > 0  # Fail only on critical
  run: exit 1
```

## Getting Help

- Check the `SCANNING_GUIDE.md` for detailed usage instructions
- Review workflow logs in the Actions tab
- Test locally using the provided scanning script
- Refer to [Trivy documentation](https://aquasecurity.github.io/trivy/) for advanced scanning options

## Rollback Plan

If you need to rollback to the enterprise version:
1. Restore the original workflow file
2. Ensure you have the necessary GitHub Advanced Security license  
3. Update badge URLs back to the original workflow
4. Remove the free edition workflow if desired

The migration is designed to be non-breaking, so both approaches can coexist if needed.