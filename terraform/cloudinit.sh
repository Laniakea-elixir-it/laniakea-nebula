#!/bin/bash
#cloud-config
set -euo pipefail
 
# Install Ansible if not present
if ! command -v ansible >/dev/null; then
	dnf install -y epel-release
	dnf install -y ansible git
fi
 
# Clone lanakea-nebula terraform script
git clone https://github.com/Laniakea-elixir-it/ansible-playbooks.git

# Install Ansible roles
export ANSIBLEPATH=/root/ansible-playbooks
export ROLESPATH=$ANSIBLEPATH/roles
mkdir -p $ROLESPATH
ansible-galaxy role install -p $ROLESPATH -r $ANSIBLEPATH/requirements.yml
 
# Execute Ansible playbook
ansible-playbook $ANSIBLEPATH/galaxy.yml -e @$ANSIBLEPATH/group_vars/galaxy.yml -e "target_hosts=localhost"
