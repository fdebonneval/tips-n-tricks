FROM ubuntu:14.04

ENV CONSUL_TEMPLATE_VERSION 0.10.0

ADD https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz /
RUN tar zxvf consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz
RUN rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz
RUN mv /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64 /consul-template
ADD files/haproxy.ctmpl /consul-template/
ADD files/entrypoint.sh /
RUN chmod +x entrypoint.sh
RUN apt-get update
RUN apt-get install -y haproxy
RUN rm /etc/haproxy/haproxy.cfg

EXPOSE 80 443 9000

CMD entrypoint.sh
