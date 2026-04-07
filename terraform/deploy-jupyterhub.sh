#!/bin/bash
set -euo pipefail

##############################
#
# Set application here
#
##############################
export APPLICATION="rstudio"

# Install Ansible if not present
if ! command -v ansible >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y ansible git

    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y epel-release
        dnf install -y ansible git

    else
        echo "Unsupported package manager. Supported: apt-get, dnf"
        exit 1
    fi
fi

# Clone Laniakea ansible-playbooks for terraform script
git clone https://github.com/Laniakea-elixir-it/ansible-playbooks.git /root/ansible-playbooks

# Install Ansible roles
export ANSIBLEPATH="/root/ansible-playbooks/$APPLICATION"
export ROLESPATH="$ANSIBLEPATH/roles"
mkdir -p "$ROLESPATH"
ansible-galaxy role install -p "$ROLESPATH" -r "$ANSIBLEPATH/requirements.yml"

# Execute Ansible playbook
ansible-playbook "$ANSIBLEPATH/$APPLICATION.yml" -e "target_hosts=localhost"
