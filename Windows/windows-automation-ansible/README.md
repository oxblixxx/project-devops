# [WinRM](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#windows-winrm) Setup for Ansible on Windows

Enable PowerShell Remoting (WinRM) on a Windows host to manage it via Ansible.

---

## 🖥️ Prerequisites

- Windows host (local or remote)
- Admin access on Windows
- Ansible control node (Linux/macOS)
- Port 5985 open

---

## ⚙️ PowerShell Setup (Run as Administrator)

```powershell
# SET NEWROK PROFILE TO PRIVATE
Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private

# Enable WinRM
Enable-PSRemoting -Force

# Open port 5985
New-NetFirewallRule -Name "WinRM Port 5985" -DisplayName "WinRM 5985" `
  -Protocol TCP -LocalPort 5985 -Action Allow -Direction Inbound -Profile Any

# Allow local user authentication
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
  -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWORD -Force

# Allow Basic auth and unencrypted traffic
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true

# Restart service
Restart-Service WinRM
```

# 👤 User Setup

Create a new user, set password for the user as well.
Ensure your local user (e.g. ansibleadmin) is in the Administrators group:

```powershell
# Define username and password
$username = "ansibleuser"
$password = ConvertTo-SecureString "MyStrongP@ssw0rd!" -AsPlainText -Force

# Create the user
New-LocalUser -Name $username -Password $password -FullName "Ansible User" -Description "User for Ansible WinRM access"

Add-LocalGroupMember -Group "Administrators" -Member "ansibleuser"
```

# 🧪 Ansible Test Command
To test the connectivity between the ansible controller node and the windows machine, run:

```sh
ansible windows -m win_ping
```
