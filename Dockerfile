FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

VOLUME /data/www/

RUN apt-get update && apt-get -y install nginx libnginx-mod-http-dav-ext 

COPY nginx/nginx.conf /etc/nginx/

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
