Deployments with Terraform
==========================

This method automatically provisions isolated computational environments with:
- Dedicated private virtual networks isolating Galaxy instances.
- Secure SSH-based access, exclusively through a Bastion host.
- Automated installation of Galaxy and dependencies using cloud-init and Ansible.
- Immediate reproducibility and strong security guarantees for handling sensitive datasets.

Requirements
------------

| **Requirement**      | **Description**                                           |
|-----------------------|-----------------------------------------------------------|
| Cloud credentials     | Authentication tokens or keys provided by the cloud platform. |
| Terraform ≥ 1.3       | Infrastructure provisioning tool.                         |
| SSH Key pair          | User-managed SSH keys for secure Bastion access.          |
| Linux VM Image        | Base Linux OS image (e.g., RockyLinux 9.3).               |
| VM Flavor             | Recommended specs: ≥ 4 CPUs, ≥ 8 GB RAM.                  |
| Network setup         | Preconfigured private network & Bastion VM.               |
