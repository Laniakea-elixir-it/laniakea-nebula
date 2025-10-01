terraform {
  required_version = ">= 1.4.0"
  required_providers {
	openstack = {
  	source  = "terraform-provider-openstack/openstack"
  	version = "~> 1.53.0"
	}
  }
}
 
provider "openstack" {
  //cloud = "recas"
  tenant_id = "3b38073bf9e04049bf0cab08b2c1c9a0"
  auth_url = "https://keystone.recas.ba.infn.it/v3"
  endpoint_overrides = {
    "network"  = "https://neutron.recas.ba.infn.it/v2.0/"
    "volumev3" = "https://cinder.recas.ba.infn.it/v3/"
    "image" = "https://glance.recas.ba.infn.it/v2/"
  }
}

# SSH key definition
resource "openstack_compute_keypair_v2" "vm_key" {
  name       = "my-keypair"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ6M41F4sf9ipRutlCNxGxpSNT9snjwIhaWbNiGKIr9 ma.tangaro@gmail.com"
}

# Private network definition
data "openstack_networking_network_v2" "private_net" {
  name = "private_net"
}

data "openstack_networking_subnet_v2" "private_subnet" {
  name = "private_subnet"
}

# Security group allowing internal SSH from Bastion only
resource "openstack_networking_secgroup_v2" "ssh_internal" {
  name    	= "ssh-internal"
  description = "Allow SSH from Bastion only"
}

# Rule: Allow SSH only from Bastion private IP
resource "openstack_networking_secgroup_rule_v2" "ssh_from_bastion" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "212.189.202.200/32"
  security_group_id = openstack_networking_secgroup_v2.ssh_internal.id
}

# Galaxy VM configuration
resource "openstack_compute_instance_v2" "galaxy_vm" {
  name        	= "galaxy-private"
  image_name  	= "RockyLinux_9.5_20241118"
  flavor_name 	= "xlarge"
  key_pair    = openstack_compute_keypair_v2.vm_key.name
  security_groups = ["default", openstack_networking_secgroup_v2.ssh_internal.name ]

  network {
    uuid = data.openstack_networking_network_v2.private_net.id
  }


  user_data = file("${path.module}/cloudinit.sh")
}
