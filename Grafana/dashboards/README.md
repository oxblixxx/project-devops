## Modified Grafana Dashboards

This directory contains the modified Grafana dashboard JSON files.

### 1. `loki-prometheus.json`

This dashboard provides a unified view of both Prometheus metrics and Loki logs.

**Features**

* **Prometheus Metrics**

  * Request rate
  * HTTP status code distribution
  * Response time (p50/p95)
  * Response sizes
  * Top API endpoints
* **Loki Logs**

  * Status code distribution
  * Log volume by HTTP method
  * Raw log stream
* **Service Filter**

  * Toggle between individual services.
  * If Prometheus is not scraping the selected service, the metrics panels will display **"No data"**, while Loki log panels will continue to show available logs.

### Before Importing

Update the datasource UIDs in the dashboard JSON file to match your Grafana instance.

Replace the placeholder values with your own datasource UIDs:

* **Prometheus datasource UID** (e.g. `cf7s8tosiu9z4c`)
* **Loki datasource UID** (e.g. `ffsf23s3jnj7kc`)

You can locate these values by searching the JSON file for the datasource UID fields and replacing them with the UIDs from your Grafana datasources.

### Prerequisites

* Docker (Docker Compose is optional)
* A running Grafana instance with both **Prometheus** and **Loki** datasources already configured and connected

### Configuring Loki and Prometheus
1. Loki Configuration

Loki must be able to read your application's logs. There are two common approaches:

Host-based applications: Configure Loki to read the application's log directory.
Dockerized applications: Use the Grafana Loki Docker logging driver.

### Install the Docker logging driver:

```sh
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

Then configure your application's docker-compose.yml (or Compose file) to use the Loki logging driver:

```yaml
logging:
  driver: loki
  options:
    loki-url: "http://localhost:3100/loki/api/v1/push"
    loki-external-labels: "job=demo-app,service_name=demo-app"
```
Note: Replace demo-app with your application's service name. The service_name label is used by the dashboard to filter logs.

2. Prometheus Configuration

Add your application to the scrape_configs section of prometheus.yml so Prometheus can collect its metrics.

```yaml
scrape_configs:
  - job_name: "my-api"
    static_configs:
      - targets:
          - "my-api:8080"
        labels:
          service_name: "my-api"
```

>Note: Ensure the service_name label matches the value used in your Loki configuration. This allows the Grafana dashboard to correlate logs and metrics for the same service.

### Refreshing the Service List

If the application does not appear in the Service dropdown after configuring Loki and Prometheus:

1. Open the dashboard in Grafana.
2. Click Settings (⚙️).
3. Navigate to Variables.
4. Select the Service variable.
5. Change Refresh to On Time Range Change.
6. Save the dashboard and reload it.

This forces Grafana to refresh the available services from the configured Loki and Prometheus datasources.
