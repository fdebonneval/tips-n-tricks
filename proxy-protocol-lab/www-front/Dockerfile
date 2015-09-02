FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV NGINX_VERSION 1.8.0-1~trusty
ENV PHP_VERSION 5.5.9+dfsg-1ubuntu4.11

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
ADD files/default.conf /tmp/
ADD files/nginx.conf /tmp/
ADD files/nginx.list /etc/apt/sources.list.d/
ADD files/entrypoint.sh /

RUN apt-get update
RUN apt-get install  openssl php5-fpm=${PHP_VERSION} -y nginx=${NGINX_VERSION}
RUN rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /etc/nginx/ssl
RUN cat /etc/php5/fpm/php.ini > toto
RUN sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' toto > /etc/php5/fpm/php.ini
RUN sed -i \
        -e "s#listen.owner = www-data#listen.owner = nginx#g" \
        -e "s#listen.group = www-data#listen.group = nginx#g" \
        /etc/php5/fpm/pool.d/www.conf
RUN rm /usr/share/nginx/html/index.html
RUN cat /tmp/default.conf > /etc/nginx/conf.d/default.conf
RUN cat /tmp/nginx.conf > /etc/nginx/nginx.conf

ADD files/server.key /etc/nginx/ssl/
ADD files/server.crt /etc/nginx/ssl/
ADD files/index.html /usr/share/nginx/html/
ADD files/12345.php /usr/share/nginx/html/
ADD files/12345-headers.php /usr/share/nginx/html/

EXPOSE 80 443

#CMD ["nginx", "-g", "daemon off;"]
