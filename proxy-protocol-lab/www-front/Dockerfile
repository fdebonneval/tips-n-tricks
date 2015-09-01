FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

ADD files/default.conf /tmp/
ADD http://nginx.org/keys/nginx_signing.key /tmp/
ADD files/nginx.list /etc/apt/sources.list.d/
RUN apt-key add /tmp/nginx_signing.key

RUN apt-get update

RUN apt-get install -y nginx
# openssl php5-fpm
#RUN ln -sf /dev/stdout /var/log/nginx/access.log
#RUN ln -sf /dev/stderr /var/log/nginx/error.log
#RUN mkdir /etc/nginx/ssl
#RUN cat /etc/php5/fpm/php.ini > toto
#RUN sed 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/' toto > /etc/php5/fpm/php.ini
#RUN rm /usr/share/nginx/html/index.html
RUN cat /tmp/default.conf > /etc/nginx/conf.d/default.conf

ADD files/server.key /etc/nginx/ssl/
ADD files/server.crt /etc/nginx/ssl/
ADD files/index.html /usr/share/nginx/html/
ADD files/12345.php /usr/share/nginx/html/
ADD files/12345-headers.php /usr/share/nginx/html/

#CMD /usr/sbin/nginx
