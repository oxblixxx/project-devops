markdown
# System Monitoring Dashboard

This project sets up a system monitoring dashboard using Grafana with Prometheus metrics.

## Prerequisites

- Linux system with `apt` package manager
- Python 3 installed
- Basic tools: `curl`

## Installation

1. Install the required Python package:
   ```bash
   sudo apt install python3-bcrypt
Generate a password hash for the admin user:

```bash
    pip3 install bcrypt
    python3 gen-pass.py
```
Make sure to save the generated password hash for configuration

Usage
To access the metrics endpoint (protected with basic auth):

bash
curl -u admin http://localhost:9090/metrics
When prompted, enter the password you generated.

Default credentials:

Username: admin

Password: admin (change this in production)

Grafana Dashboard
Import this pre-built dashboard into Grafana for system monitoring:
https://grafana.com/grafana/dashboards/18664-system-usage/

Configuration
Make sure your Prometheus instance is configured to scrape the metrics endpoint

Configure Grafana to use your Prometheus as a data source

Import the dashboard using the ID 18664

Security Note
Always change default credentials in production environments

Consider using HTTPS for metrics endpoints

Restrict access to monitoring endpoints


You can customize this further by adding:
- More detailed installation steps
- Screenshots of the dashboard
- Configuration file examples
- Troubleshooting section
- License information

Would you like me to add any of these sections or make any other adjustments to the README?
