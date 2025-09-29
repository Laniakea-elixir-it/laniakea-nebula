#!/bin/bash
#cloud-config
set -euo pipefail
 
# Install Ansible if not present
if ! command -v ansible >/dev/null; then
	dnf install -y epel-release
	dnf install -y ansible git
fi
 
# Create Ansible requirements.yml
cat >/root/requirements.yml <<'YAML'
- src: galaxyproject.galaxy
  version: 0.10.14
- src: galaxyproject.nginx
  version: 0.7.1
- src: galaxyproject.postgresql
  version: 1.1.2
- src: galaxyproject.postgresql_objects
  version: 1.2.0
- src: galaxyproject.miniconda
  version: 0.3.1
- src: usegalaxy_eu.certbot
  version: 0.1.11
YAML
 
# Install Ansible roles
mkdir -p /root/roles
ansible-galaxy install -p /root/roles -r /root/requirements.yml
 
# Galaxy setup Ansible Playbook
cat >/root/galaxy.yml <<'YAML'
- hosts: localhost
  become: true
  vars:
	postgresql_objects_users:
  	- name: galaxy
    	password: galaxy_db_pass
	postgresql_objects_databases:
  	- name: galaxy
    	owner: galaxy
  pre_tasks:
	- name: Install ACL dependencies
  	package:
    	name: acl
    	state: present
  roles:
	- galaxyproject.postgresql
	- role: galaxyproject.postgresql_objects
  	become_user: postgres
YAML
 
# Execute Ansible playbook
ansible-playbook -i "localhost," -c local /root/galaxy.yml

