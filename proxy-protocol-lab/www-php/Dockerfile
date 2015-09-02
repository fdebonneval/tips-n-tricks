FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV PHP_VERSION 5.5.9+dfsg-1ubuntu4.11

RUN apt-get update
RUN apt-get install -y php5-fpm=${PHP_VERSION}
RUN rm -rf /var/lib/apt/lists/*

RUN cat /etc/php5/fpm/php.ini > toto
RUN sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' toto > /etc/php5/fpm/php.ini
#RUN sed -i \
#        -e "s#listen.owner = www-data#listen.owner = nginx#g" \
#        -e "s#listen.group = www-data#listen.group = nginx#g" \
#        /etc/php5/fpm/pool.d/www.conf

VOLUME ["/var/run"]
#CMD ["/usr/sbin/php5-fpm"]
