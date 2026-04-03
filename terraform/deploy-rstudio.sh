#!/bin/bash
#cloud-config
set -euo pipefail
 
# Install Ansible if not present
if ! command -v ansible >/dev/null; then
	dnf install -y epel-release
	dnf install -y ansible git
fi
 
# Clone lanakea ansible-playbooks for terraform script
git clone https://github.com/Laniakea-elixir-it/ansible-playbooks.git /root/ansible-playbooks

# Install Ansible roles
export ANSIBLEPATH=/root/ansible-playbooks/rstudio
export ROLESPATH=$ANSIBLEPATH/roles
mkdir -p $ROLESPATH
ansible-galaxy role install -p $ROLESPATH -r $ANSIBLEPATH/requirements.yml
 
# Execute Ansible playbook
ansible-playbook $ANSIBLEPATH/rstudio.yml -e "target_hosts=localhost"
