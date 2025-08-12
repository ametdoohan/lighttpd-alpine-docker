FROM alpine:3.19

LABEL maintainer="amet doohan <ametdoohan@live.com>"

LABEL version="1.1"
LABEL description="lighttpd running on port 80"

EXPOSE 80

RUN apk add --update --no-cache lighttpd && \
	rm -rf /var/cache/apk/* && \
	lighttpd -t -f /etc/lighttpd/lighttpd.conf && \
	echo "Lighttpd is running..." > /var/www/localhost/htdocs/index.html && \
	addgroup www && \
	adduser -D -H -s /sbin/nologin -G www www

ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

