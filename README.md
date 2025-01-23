# Project DevOps

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
