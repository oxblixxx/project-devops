# This setup runs a shell script every 1 second using systemd services and timers. Logs are handled by systemd journal, so no manual log rotation is required.

1. Create the Script.
Create a [script](./api-call.sh) file and save it in a preferered location `/usr/local/bin/api-call.sh`. Make the file executable, by running this command `chmod +x /usr/local/bin/api-call.sh`

2. Create the Service

Create a [service](./api-call.service) file in the system directory `/etc/systemd/system/api-call.service` 

3. Create the Timer

Create /etc/systemd/system/api-call.timer:

[Unit]
Description=Run API Runner every second

[Timer]
OnUnitActiveSec=1s
AccuracySec=1ms
Unit=api-call.service

[Install]
WantedBy=timers.target

4. Reload and Enable
sudo systemctl daemon-reload
sudo systemctl enable --now api-call.timer

5. Monitor Logs

Check service logs:

journalctl -u api-call.service -f


Check timer status:

systemctl status api-call.timer

Notes

Runs every 1 second (~86,400 calls/day).

Logs are stored in systemd journal and rotated automatically.

To adjust frequency, change OnUnitActiveSec=1s in the timer.

To prevent log growth, tune /etc/systemd/journald.conf with limits (SystemMaxUse, RuntimeMaxUse).
