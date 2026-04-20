# Systemd Timer: Run API Script Every 1 Second

This setup runs a shell script every 1 second using **systemd services and timers**. Logs are handled automatically by the **systemd journal**, so no manual log rotation is required.

---

## 1. Create the Script

Create the script file:

```bash
/usr/local/bin/api-call.sh

Make it executable:

chmod +x /usr/local/bin/api-call.sh
Example script:
#!/bin/bash

response=$(curl -s -X GET "http://your-api-endpoint.com")

echo "[$(date)] API response: $response"
2. Create the Systemd Service

Create the service file:

/etc/systemd/system/api-call.service
Service configuration:
[Unit]
Description=API Runner Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/api-call.sh
StandardOutput=journal
StandardError=journal
3. Create the Systemd Timer

Create the timer file:

/etc/systemd/system/api-call.timer
Timer configuration:
[Unit]
Description=Run API Runner every second

[Timer]
OnUnitActiveSec=1s
AccuracySec=1ms
Unit=api-call.service

[Install]
WantedBy=timers.target
4. Reload Systemd and Enable Timer

Run the following commands:

sudo systemctl daemon-reload
sudo systemctl enable --now api-call.timer
5. Monitor Logs
View service logs:
journalctl -u api-call.service -f
Check timer status:
systemctl status api-call.timer
6. Notes
Runs every 1 second (~86,400 executions per day).
Logs are stored in the systemd journal and automatically rotated.
No manual log rotation is required.
7. Adjusting Frequency

To change how often the script runs, modify:

OnUnitActiveSec=1s

Examples:

5s → every 5 seconds
10s → every 10 seconds
1min → every minute
8. Preventing Log Growth (Recommended)

Edit journald configuration:

/etc/systemd/journald.conf

Set limits:

SystemMaxUse=500M
RuntimeMaxUse=200M

Then restart journald:

sudo systemctl restart systemd-journald
