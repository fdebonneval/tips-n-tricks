FROM ubuntu:14.04

ENV CONSUL_TEMPLATE_VERSION 0.10.0

ADD https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz /
ADD files/haproxy.ctmpl /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64/
ADD files/entrypoint.sh /

RUN tar zxvf consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz
RUN chmod +x entrypoint.sh
RUN rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tar.gz

CMD entrypoint.sh consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64
