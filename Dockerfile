FROM debian:bullseye
MAINTAINER yohan <783b8c87@scimetis.net>
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "deb http://ftp.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get -y install apache2 && apt-get -y install python3-certbot-apache -t bullseye-backports
RUN a2enmod ssl proxy proxy_http rewrite headers proxy_wstunnel
EXPOSE 80
EXPOSE 443
COPY apache2.conf /etc/apache2/
COPY other-vhosts-access-log.conf /etc/apache2/conf-available/
RUN rm -f /etc/apache2/sites-enabled/*
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
