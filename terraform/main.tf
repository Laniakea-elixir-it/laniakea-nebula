terraform {
  required_providers {
	cloudprovider = {
  	source  = "<cloud-provider-specific>/provider"
  	version = "~> X.Y.Z"
	}
  }
}
 
provider "cloudprovider" {
  # authentication details here
}
 
# SSH Key definition
resource "cloudprovider_ssh_key" "vm_key" {
  name   	= var.public_key["name"]
  public_key = var.public_key["public_key"]
}
 
# Private network definition
resource "cloudprovider_network" "private_network" {
  name = "private_network"
}
 
# Security group allowing internal SSH from Bastion only
resource "cloudprovider_security_group" "ssh_internal" {
  name    	= "ssh-internal"
  description = "Allow SSH from Bastion only"
 
  ingress {
	from_port   = 22
	to_port 	= 22
	protocol	= "tcp"
	cidr_blocks = ["<BASTION_PRIVATE_IP>/32"]
  }
}
 
# Galaxy VM configuration
resource "cloudprovider_compute_instance" "galaxy_vm" {
  name        	= "galaxy-private"
  image_name  	= "RockyLinux 9.3"
  flavor_name 	= "medium"
  ssh_key_name	= cloudprovider_ssh_key.vm_key.name
  security_groups = [cloudprovider_security_group.ssh_internal.id]
 
  network {
	name = cloudprovider_network.private_network.name
  }
 
  user_data = file("${path.module}/cloudinit.sh")
}

