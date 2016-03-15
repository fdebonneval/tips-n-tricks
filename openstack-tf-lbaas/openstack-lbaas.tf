provider "openstack" {
# endpoints, credentials are taken from environment variables
  insecure = "true"
}

# Networks creation
resource "openstack_networking_network_v2" "tf-net-north" {
  name = "tf-net-north"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "tf-net-lb-pool" {
  name = "tf-net-lb-pool"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "tf-subnet-north" {
  network_id = "${openstack_networking_network_v2.tf-net-north.id}"
  cidr = "10.128.0.0/24"
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "tf-subnet-lb-pool" {
  network_id = "${openstack_networking_network_v2.tf-net-lb-pool.id}"
  cidr = "10.254.0.0/24"
  ip_version = 4
}

# Floatingips creation
resource "openstack_networking_floatingip_v2" "tf-floating-bst" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "tf-floating-00" {
  pool = "public"
}

# Router creation
resource "openstack_networking_router_v2" "tf-router-00" {
  name = "tf-router-00"
  admin_state_up = "true"
  external_gateway = "6ea98324-0f14-49f6-97c0-885d1b8dc517"
}

resource "openstack_networking_router_interface_v2" "tf-router-north" {
    router_id = "${openstack_networking_router_v2.tf-router-00.id}"
    subnet_id = "${openstack_networking_subnet_v2.tf-subnet-north.id}"
}

# Security groups
resource "openstack_compute_secgroup_v2" "tf-lb-sg-icmp-ssh" {
  name = "tf-lb-sg-icmp-ssh"
  description = "ICMP and SSH Security groups"
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "tf-sg-80-443" {
  name = "tf-sg-80-443"
  description = "80 and 443 Security groups"
  rule {
    ip_protocol = "tcp"
    from_port = "80"
    to_port = "80"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "tcp"
    from_port = "443"
    to_port = "443"
    cidr = "0.0.0.0/0"
  }
}

# Create bastion server
resource "openstack_compute_instance_v2" "tf-bst-00" {
  name = "tf-bst-00"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  floating_ip = "${openstack_networking_floatingip_v2.tf-floating-bst.address}"
  image_id = "ae3082cb-fac1-46b1-97aa-507aaa8f184f"
  flavor_id = "17"
  key_pair = "foucault"
  security_groups = ["tf-lb-sg-icmp-ssh"]
}

# Create front server
resource "openstack_compute_instance_v2" "tf-front-00" {
  name = "tf-front-00"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_id = "ae3082cb-fac1-46b1-97aa-507aaa8f184f"
  flavor_id = "17"
  key_pair = "foucault"
  security_groups = ["tf-lb-sg-icmp-ssh","tf-sg-80-443"]
  user_data = "${file(\"files/cloud-init-front.sh\")}"
}

resource "openstack_compute_instance_v2" "tf-front-01" {
  name = "tf-front-01"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_id = "ae3082cb-fac1-46b1-97aa-507aaa8f184f"
  flavor_id = "17"
  key_pair = "foucault"
  security_groups = ["tf-lb-sg-icmp-ssh","tf-sg-80-443"]
  user_data = "${file(\"files/cloud-init-front.sh\")}"
}

# LBaaS HTTP pool creation
resource "openstack_lb_pool_v1" "tf-lbpool-00" {
  name = "tf-lbpool-00"
  protocol = "HTTP"
  subnet_id = "${openstack_networking_subnet_v2.tf-subnet-north.id}"
  lb_method = "SOURCE_IP"
  member {
    address = "${openstack_compute_instance_v2.tf-front-00.access_ip_v4}"
    port = 80
    admin_state_up = "true"
  }
  member {
    address = "${openstack_compute_instance_v2.tf-front-01.access_ip_v4}"
    port = 80
    admin_state_up = "true"
  }
}

# LBaaS HTTP VIP creation
resource "openstack_lb_vip_v1" "tf-lbvip-00" {
  name = "tf-lbvip-00"
  subnet_id = "${openstack_networking_subnet_v2.tf-subnet-lb-pool.id}"
  protocol = "HTTP"
  port = 80
  pool_id = "${openstack_lb_pool_v1.tf-lbpool-00.id}"
#  floating_ip = "${openstack_networking_floatingip_v2.tf-floating-00.id}"
}

# LBaaS tcp/443 pool creation
resource "openstack_lb_pool_v1" "tf-lbpool-01" {
  name = "tf-lbpool-01"
  protocol = "TCP"
  subnet_id = "${openstack_networking_subnet_v2.tf-subnet-north.id}"
  lb_method = "ROUND_ROBIN"
  member {
    address = "${openstack_compute_instance_v2.tf-front-00.access_ip_v4}"
    port = 443
    admin_state_up = "true"
  }
  member {
    address = "${openstack_compute_instance_v2.tf-front-01.access_ip_v4}"
    port = 443
    admin_state_up = "true"
  }
}

# LBaaS tcp/443 VIP creation
resource "openstack_lb_vip_v1" "tf-lbvip-01" {
  name = "tf-lbvip-01"
  subnet_id = "${openstack_networking_subnet_v2.tf-subnet-lb-pool.id}"
  protocol = "TCP"
  port = 443
  pool_id = "${openstack_lb_pool_v1.tf-lbpool-01.id}"
  floating_ip = "${openstack_networking_floatingip_v2.tf-floating-00.address}"
}

# Outputs
output "bst-floatingip" {
  value = "neutron floatingip-associate ${openstack_networking_floatingip_v2.tf-floating-bst.id} ${openstack_compute_instance_v2.tf-bst-00.access_ip_v4}"
}
output "lb-floatingip" {
  value = "neutron floatingip-associate ${openstack_networking_floatingip_v2.tf-floating-00.id} [LB_VIP_PORT_ID]"
}
