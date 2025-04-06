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
