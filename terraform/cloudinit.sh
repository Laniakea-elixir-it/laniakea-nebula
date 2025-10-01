#!/bin/bash
#cloud-config
set -euo pipefail
 
# Install Ansible if not present
if ! command -v ansible >/dev/null; then
	dnf install -y epel-release
	dnf install -y ansible git
fi
 
# Clone lanakea-nebula terraform script
git clone https://github.com/Laniakea-elixir-it/laniakea-nebula.git /root/laniakea-nebula

# Install Ansible roles
export ANSIBLEPATH=/root/laniakea-nebula/terraform/ansible
export ROLESPATH=$ANSIBLEPATH/roles
mkdir -p $ROLESPATH
ansible-galaxy role install -p $ROLESPATH -r $ANSIBLEPATH/requirements.yml
 
# Execute Ansible playbook
ansible-playbook $ANSIBLEPATH/deploy-galaxy.yml -e @$ANSIBLEPATH/group_vars/galaxy.yml
