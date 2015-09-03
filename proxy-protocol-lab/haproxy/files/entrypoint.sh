#!/bin/bash

consul-template -consul=${CONSUL_PORT_8500_TCP_ADDR}:8500 -template="./haproxy.ctmpl:/etc/haproxy/haproxy.cfg:"&

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
