# Project DevOps
This project involves setting up my home-lab, on vagrant boxes. So setting up vagrant, I encountered issues and I had to do some uninstall and install, issues with powershell as well. My current vagrant version is 2.4.0 and my virtualbox is 7.0 which is my preferred provider. When I run vagrant up, it freezes, but when I go ahead to look at virtualbox, it shows the box is provisioned, but for cases where I want to provision more than one, it doesn't provision more than one. I am yet to figure that out, but I making use of one node now, later when I want to practice k8s, I will look into configuring it to have more nodes. My Network is `Bridged adapter` as I need a public ip address. That's my current setup. So I want to setup all of this within my homelab. Firstly I want to setup my environment to have docker, be able to provision users and copy the user keys.

This project involves setting up a variety of open-source tools, each serving different use cases, including:

- **Traefik**: A dynamic reverse proxy for managing traffic.
- **Zabbix**: Monitoring tool for tracking system performance and uptime.
- **Uptime Kuma**: A self-hosted monitoring solution for uptime tracking.
- **Grafana**: A powerful visualization and monitoring platform.
- **Authentik**: A single sign-on (SSO) solution for identity management.
- **Vaultwarden**: A password manager for secure credential storage.

Each component plays a critical role in enhancing the efficiency and security of the infrastructure.

## Setup Instructions

To begin the project, **Traefik** should be deployed first, followed by the other tools in any order of your choice.

### 1. **Create a network for Traefik**:
Run the following command to create a separate Docker network for Traefik:
```bash
docker network create traefik
```
Now change directory to `Traefik` directory.
```bash
cd Traefik
```
After deploying Traefik, you can continue with the setup of the other tools in your desired order by changing directory to the tools.


```powershell
# Enables the WinRM service and sets up the HTTP listener
Enable-PSRemoting -Force

# Opens port 5985 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5985]'
    Direction   = 'Inbound'
    DisplayName = 'Windows Remote Management (HTTP-In)'
    LocalPort   = 5985
    Profile     = 'Any'
    Protocol    = 'TCP'
}
New-NetFirewallRule @firewallParams

# Allows local user accounts to be used with WinRM
# This can be ignored if using domain accounts
$tokenFilterParams = @{
    Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Name         = 'LocalAccountTokenFilterPolicy'
    Value        = 1
    PropertyType = 'DWORD'
    Force        = $true
}
New-ItemProperty @tokenFilterParams

winrm quickconfig

# For basic/HTTP lab use (ok inside a trusted network)
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
```
