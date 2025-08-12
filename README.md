## Docker image alpine with lighttpd web server

[![Container Security](https://github.com/ametdoohan/lighttpd-alpine-docker/actions/workflows/security-scan.yml/badge.svg)](https://github.com/ametdoohan/lighttpd-alpine-docker/actions/workflows/security-scan.yml)

A lightweight web server based on Alpine Linux with automated vulnerability scanning.

### to pull:

```bash
docker pull ametdoohan/lighttpd-alpine:latest
```

### to run the container on port 8080:

```bash
docker run -d -p 8080:80 ametdoohan/lighttpd-alpine:latest
```

## Security

This project implements automated vulnerability scanning using [Trivy](https://trivy.dev/). See [SECURITY.md](SECURITY.md) for details on security practices and scanning procedures.
