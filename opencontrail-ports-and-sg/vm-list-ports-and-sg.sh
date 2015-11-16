#!/bin/bash

# Get token from Keystone
# token=$(keystone token-get | grep " id " | awk {'print $4'} || exit)

# Get the endpoints list
get_endpoints () {
  curl -s -i -X POST ${OS_AUTH_URL}/tokens \
    -H "Content-Type: application/json" \
    -H "User-Agent: python-keystoneclient" \
    -d '{"auth": {"tenantName": "'"${OS_TENANT_NAME}"'", "passwordCredentials": {"username": "'"${OS_USERNAME}"'", "password": "'"${OS_PASSWORD}"'"}}}' | tail -1
}

get_secgroup () {
  curl -s -i $neutron/v2.0/security-groups/${1}.json \
    -X GET -H "X-Auth-Token: ${token}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: python-neutronclient" | tail -1
}

get_vm_ports () {
  curl -s -i $neutron/v2.0/ports.json?device_id=${1} \
    -X GET -H "X-Auth-Token: ${token}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: python-neutronclient" | tail -1
}

get_subnet_details () {
  curl -s -i $neutron/v2.0/subnets/${1}.json \
    -X GET -H "X-Auth-Token: ${token}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: python-neutronclient" | tail -1
}

get_port_details () {
  curl -s -i -X GET $neutron/v2.0/ports/${1}.json \
    -H "User-Agent: python-neutronclient" \
    -H "Accept: application/json" \
    -H "X-Auth-Token: ${token}" | tail -1
}

get_default_secgroup () {
  curl -s -i $neutron/v2.0/security-groups.json?fields=id&name=default \
    -H "User-Agent: python-neutronclient" \
    -H "Accept: application/json" \
    -H "X-Auth-Token: ${token}"
}

echo "Get Token from keystone"
token=$(get_endpoints | jq -r .access.token.id)
echo "Token : ${token}"
echo "------------------------------------------------"

echo "Get endpoints from Keystone"
neutron=$(get_endpoints | jq -r '.access.serviceCatalog[] | select(.name == "neutron") | .endpoints[].publicURL')
echo "Neutron : ${neutron}"
echo "------------------------------------------------"


for i in $@; 
do
  
  echo "####  Listing ports for VM ${i}  ####"
  portsid=$(get_vm_ports $i | jq -r '.ports[].id')

  for j in $portsid;
  do
    secgroups=$(get_port_details ${j} | jq -r '.port.security_groups[]')

    for k in $secgroups;
    do
      echo "Getting security-group ${k} for port ${j} for VM ${i}"
#      get_secgroup $k |  jq '.security_group.security_group_rules[] | {remote: .remote_ip_prefix, direction: .direction, proto: .protocol, port_min: .port_range_min, port_max: .port_range_max}'
      get_secgroup $k |  jq '.security_group | .name, .security_group_rules[]'
    done
    
  done

  
done
