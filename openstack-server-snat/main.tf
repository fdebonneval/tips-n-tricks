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
  external_gateway = "6ea98324-0f14-49f6-97c0-885d1b8dc517"
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

resource "openstack_networking_floatingip_v2" "floating-00" {
  region = "fr1"
  pool = "public"
}

# Create server
resource "openstack_compute_instance_v2" "tf-vm" {
  name = "tf-vm"
  network {
    uuid = "${openstack_networking_network_v2.tf-net-north.id}"
  }
  image_id = "ae3082cb-fac1-46b1-97aa-507aaa8f184f"
  flavor_id = "17"
  key_pair = "foucault"
  security_groups = ["${openstack_compute_secgroup_v2.tf-sg-icmp-ssh.name}"]
  floating_ip = "${openstack_networking_floatingip_v2.floating-00.address}"
  count = 2
}
