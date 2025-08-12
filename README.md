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

## Security Scanning (Free GitHub Edition)

This project provides comprehensive container vulnerability scanning that works with free GitHub accounts:

### Features
- ✅ **Free GitHub Compatible**: No GitHub Enterprise or Advanced Security required  
- 🔍 **Automated Scanning**: Runs on PRs, pushes, and weekly schedules
- 📊 **Multiple Report Formats**: JSON, table, and summary formats
- 💬 **PR Comments**: Automatic vulnerability summaries in pull requests
- 📦 **Workflow Artifacts**: Downloadable scan results with 30-day retention
- 🚨 **Build Failures**: Fails builds on critical/high severity vulnerabilities

### Quick Local Scanning

```bash
# Run automated container scan
./scripts/container-scan.sh --install-trivy

# Scan existing image
./scripts/container-scan.sh --no-build -i your-image:latest
```

## Security

This project implements automated vulnerability scanning using [Trivy](https://trivy.dev/). See [SECURITY.md](SECURITY.md) for details on security practices and scanning procedures.
