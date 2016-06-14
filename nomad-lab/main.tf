# Configure the OpenStack Provider

provider "openstack" {
# endpoints, credentials are taken from environment variables
#  insecure = "true"
}

# Networks creation
resource "openstack_networking_network_v2" "tf-net-north" {
  name = "tf-net-north"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "tf-subnet-north" {
  network_id = "${openstack_networking_network_v2.tf-net-north.id}"
  cidr = "192.168.199.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "tf-router" {
  name = "tf-router-north"
  admin_state_up = "true"
  external_gateway = "b5dd7532-1533-4b9c-8bf9-e66631a9be1d"
}

resource "openstack_networking_router_interface_v2" "tf-router-north" {
    router_id = "${openstack_networking_router_v2.tf-router.id}"
    subnet_id = "${openstack_networking_subnet_v2.tf-subnet-north.id}"
}

resource "openstack_compute_secgroup_v2" "tf-sg-icmp-ssh" {
  name = "tf-sg-icmp-ssh"
  description = "ICMP and SSH Security groups"
  rule {
    ip_protocol = "tcp"
    from_port = "22"
    to_port = "22"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "tf-sg-consul" {
  name = "tf-sg-consul"
  description = "Consul Security groups"
  rule {
    ip_protocol = "tcp"
    from_port = "8400"
    to_port = "8400"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "tf-sg-consul-raft" {
  name = "tf-sg-consul-raft"
  description = "Consul Security groups"
  rule {
    ip_protocol = "tcp"
    from_port = "8300"
    to_port = "8300"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "tcp"
    from_port = "8301"
    to_port = "8301"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "udp"
    from_port = "8301"
    to_port = "8301"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_networking_floatingip_v2" "nomad-fip-00" {
  region = "fr2"
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "nomad-fip-01" {
  region = "fr2"
  pool = "public"
}

# Create server
resource "openstack_compute_instance_v2" "tf-nomad-bst-00" {
  name = "tf-nomad-bst-00"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_name = "Ubuntu 14.04"
  flavor_id = "43"
  key_pair = "foucault-perso"
  metadata {
    project = "nomad"
    role = "bastion"
  }
  security_groups = ["${openstack_compute_secgroup_v2.tf-sg-icmp-ssh.name}"]
  floating_ip = "${openstack_networking_floatingip_v2.nomad-fip-00.address}"
  count = 1
}

resource "openstack_compute_instance_v2" "tf-nomad-rpx-00" {
  name = "tf-nomad-rpx-00"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_name = "Ubuntu 14.04"
  flavor_id = "43"
  key_pair = "foucault-perso"
  metadata {
    project = "nomad"
    role = "rpx"
  }
  security_groups = ["${openstack_compute_secgroup_v2.tf-sg-icmp-ssh.name}"]
  floating_ip = "${openstack_networking_floatingip_v2.nomad-fip-01.address}"
  count = 1
}

resource "openstack_compute_instance_v2" "tf-nomad-reg" {
  name = "tf-nomad-reg-${format("%02d", count.index + 1)}"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_name = "Ubuntu 14.04"
  flavor_id = "43"
  key_pair = "foucault-perso"
  metadata {
    project = "nomad"
    role = "consul"
  }
  security_groups = ["${openstack_compute_secgroup_v2.tf-sg-icmp-ssh.name}","${openstack_compute_secgroup_v2.tf-sg-consul.name}","${openstack_compute_secgroup_v2.tf-sg-consul-raft.name}"]
  count = 3
}

resource "openstack_compute_instance_v2" "tf-nomad-ctn" {
  name = "tf-nomad-ctn-${format("%02d", count.index + 1)}"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_name = "Ubuntu 14.04"
  flavor_id = "43"
  key_pair = "foucault-perso"
  metadata {
    project = "nomad"
    role = "nomad"
  }
  security_groups = ["${openstack_compute_secgroup_v2.tf-sg-icmp-ssh.name}"]
  count = 3
}
