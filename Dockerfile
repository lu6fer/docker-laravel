FROM debian:latest

MAINTAINER Lu6fer <lu6fer2604@gmail.com>

RUN mkdir -p /opt/install

ADD install.sh /opt/install/install.sh
ADD run.sh /opt/install/run.sh
#ADD config.sh /config.sh
ADD maria-password.txt /opt/install/maria-password.txt
ADD create-server.sh /usr/local/bin/create-server
ADD sample.conf /opt/install/sample.conf

RUN chmod +x /opt/install/*.sh
RUN mkdir -p /var/cache/laravel-install
RUN mkdir -p /srv/http

RUN /opt/install/install.sh
#RUN /config.sh
ADD laravel.conf /etc/nginx/conf.d/laravel.conf

EXPOSE 80
EXPOSE 3306
EXPOSE 22

CMD ["/opt/install/run.sh"]
