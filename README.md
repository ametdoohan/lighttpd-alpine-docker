Docker image alpine with lighttpd web server (only 14MB)

to pull:
{% highlight bash %}
docker pull ametdoohan/lighttpd-alpine:latest
{% endhighlight %}

to run the container on port 8080:
{% highlight bash %}
docker run -d -p 8080:80 ametdoohan/lighttpd-alpine:latest
{% endhighlight %}
