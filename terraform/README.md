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

Network topology
----------------

```text
User ---> SSH Bastion (public IP) ---> Galaxy Instance (private IP)
               |
               |---- Private Virtual Network (No Public Access)

```

- Public Access: Only available via Bastion host.
- Galaxy VM: Deployed entirely within a secure, private network.

Terraform files Configuration
-----------------------------

In the ``main.tf`` replace the ``BASTION_PRIVATE_IP`` with the Bastion host’s private IP address, ensuring SSH access only through this host.

The cloud-init script automates Galaxy’s setup at VM boot.

Bastion configuration
---------------------

- Deploy a small VM with public IP, hardened security, and minimal software installed.
- Configure firewall rules allowing SSH access only from known external IPs.
- Use secure authentication (SSH keys or MFA) to access the Bastion.
- Forward SSH connections exclusively to the private Galaxy instance.

Example SSH connection from the user’s computer:

```
ssh -i ~/.ssh/user_bastion_key -J <user>@<bastion-public-ip> rocky@<galaxy-private-ip>
```

Deploy
------

Execute Terraform:

```
terraform init
terraform apply
```

Post-deployment validation via Bastion host:

```
ssh -i ~/.ssh/user_bastion_key -J <user>@<bastion-public-ip> rocky@<galaxy-private-ip>
sudo systemctl status postgresql galaxy  # Check services
```
