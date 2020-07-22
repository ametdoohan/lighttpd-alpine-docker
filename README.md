## Docker image alpine with lighttpd web server

### to pull:

```bash
docker pull ametdoohan/lighttpd-alpine:latest
```

### to run the container on port 8080:

```bash
docker run -d -p 8080:80 ametdoohan/lighttpd-alpine:latest
```
