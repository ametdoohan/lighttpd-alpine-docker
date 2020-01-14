Docker image alpine with lighttpd web server (only 14MB)

to pull:

docker pull ametdoohan/lighttpd-alpine:latest

to run the container on port 8080:

docker run -d -p 8080:80 ametdoohan/lighttpd-alpine:latest

