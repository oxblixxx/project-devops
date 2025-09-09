# Ansible Windows Setup

This repository contains documentation and scripts on WINDOWS project worked on and how to configure Windows hosts for Ansible management using WinRM.

## 📌 Contents

- `winrm-setup.md` – Steps to enable and configure WinRM on a Windows machine.
- PowerShell snippets for:
  - Enabling WinRM
  - Opening firewall ports
  - Setting local account policies
  - Enabling basic auth and unencrypted communication
- Ansible playbooks for:
  - Testing WinRM connectivity
  - Installing Chocolatey
  - Installing .NET Framework 4.8
  - Managing Windows services

## ⚙️ Requirements

- Windows Server or Workstation (2012+)
- Admin privileges on the Windows host
- Ansible control node (Linux/macOS)
- Port `5985` open between Ansible and the target Windows host

## 🧪 Quick Test

Run from your Ansible control node:

```bash
ansible windows -m win_ping \
  -u <username> -k --ask-pass \
  --connection=winrm --port=5985 \
  --extra-vars "ansible_winrm_transport=basic ansible_winrm_server_cert_validation=ignore"
