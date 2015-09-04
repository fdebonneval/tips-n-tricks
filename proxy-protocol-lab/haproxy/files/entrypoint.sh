#!/bin/bash

/consul-template/consul-template -consul=${CONSUL_PORT_8500_TCP_ADDR}:8500 -template="/consul-template/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:"&

while test ! -f /etc/haproxy/haproxy.cfg
do
  echo "waiting for consul-template to generate /etc/haproxy/haproxy/conf"
  sleep 1
done

/usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
sleep 1

while test -f /var/run/haproxy.pid
do SUM=$(md5sum /etc/haproxy/haproxy.cfg | awk '{print $1}')
  if [ "${SUM}" != "${SUM0}" ]
  then
    echo "config file changed, reloading"
    haproxy -p /var/run/haproxy.pid -f /etc/haproxy/haproxy.cfg -sf $(cat /var/run/haproxy.pid)
    SUM0=${SUM}
  fi
  sleep 5
done
echo "terminated"
kill %1
