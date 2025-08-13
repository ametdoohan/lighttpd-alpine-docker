## Docker image alpine with lighttpd web server

[![Container Security](https://github.com/ametdoohan/lighttpd-alpine-docker/actions/workflows/container-scan-free.yml/badge.svg)](https://github.com/ametdoohan/lighttpd-alpine-docker/actions/workflows/container-scan-free.yml)

A lightweight web server based on Alpine Linux with automated vulnerability scanning compatible with **free GitHub accounts**.

### to pull:

```bash
docker pull ametdoohan/lighttpd-alpine:latest
```

### to run the container on port 8080:

```bash
docker run -d -p 8080:80 ametdoohan/lighttpd-alpine:latest
```

## Security Scanning (Enhanced PR Integration)

This project provides comprehensive container vulnerability scanning with enhanced pull request integration that works with free GitHub accounts:

### ✨ Enhanced Features
- ✅ **Free GitHub Compatible**: No GitHub Enterprise or Advanced Security required  
- 🔍 **Automated Scanning**: Runs on PRs, pushes, and weekly schedules
- 📊 **Multiple Report Formats**: JSON, table, and summary formats
- 💬 **Enhanced PR Comments**: Rich formatting with visual indicators and remediation guidance
- 🏷️ **Automatic PR Labeling**: Labels PRs based on security scan results
- ✅ **GitHub Status Checks**: Shows scan status directly in PR interface
- 📦 **Workflow Artifacts**: Downloadable scan results with 30-day retention
- 🚨 **Build Failures**: Fails builds on critical/high severity vulnerabilities
- 🛠️ **Remediation Guidance**: Actionable steps to resolve vulnerabilities

### 🎯 PR Integration Features

When you create a pull request, the enhanced security scanning provides:

1. **🔄 Real-time Status Updates**: See scan progress in the PR status checks
2. **🏷️ Automatic Labels**: PRs are labeled based on scan results:
   - `security-clean` ✅ - No vulnerabilities found
   - `security-review` ⚠️ - Medium severity issues (review recommended)
   - `security-risk` 🚨 - Critical/high severity issues (blocks merge)
   - `security-error` 💥 - Scan failed (needs investigation)

3. **📋 Rich PR Comments**: Detailed scan results with:
   - Visual vulnerability summary with emojis and status indicators
   - Scanner metadata and scan timestamp
   - Actionable remediation guidance
   - Direct links to detailed results and documentation
   - Collapsible troubleshooting section

4. **🚫 Merge Protection**: PRs with critical/high vulnerabilities cannot be merged until resolved

### Quick Local Scanning

```bash
# Run automated container scan
./scripts/container-scan.sh --install-trivy

# Scan existing image
./scripts/container-scan.sh --no-build -i your-image:latest
```

## Security

This project implements automated vulnerability scanning using [Trivy](https://trivy.dev/). See [SECURITY.md](SECURITY.md) for details on security practices and scanning procedures.
