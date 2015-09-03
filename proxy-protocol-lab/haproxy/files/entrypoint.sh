#!/bin/bash

CONSUL_TEMPLATE_PATH=$1

${CONSUL_TEMPLATE_PATH}/consul-template -consul=${CONSUL_PORT_8500_TCP_ADDR}:8500 -template="${CONSUL_TEMPLATE_PATH}/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:"&

/usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg

while true
do SUM=$(md5sum /etc/haproxy/haproxy.cfg | awk '{print $1}')
  if [ "${SUM}" != "${SUM0}" ]
  then
    echo "config file changed, reloading"
    kill -HUP $(cat /var/run/haproxy)
    SUM0=${SUM}
  fi
  sleep 5
done
