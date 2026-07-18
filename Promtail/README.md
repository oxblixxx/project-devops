# Promtail Setup Guide

This document explains how to set up **Promtail** as the log collector in a **Loki + Grafana** logging stack.

- **Promtail** collects and ships logs.
- **Loki** stores the logs.
- **Grafana** is used for querying and visualizing the logs.

This guide assumes that Docker and Docker Compose are already installed.

---

## 1. Create the Promtail Log Directory

Before starting the containers, create a directory where Promtail will collect all application logs.

```sh
sudo mkdir -p /var/log/promtail
```

---

## 2. Configure Docker Volume

Reference the Promtail log directory as a volume in your `docker-compose.yaml`.

Example:

```yaml
volumes:
  - /var/log/promtail:/var/log/promtail:ro
```

---

## 3. Bind Mount Application Logs

Instead of using symbolic links, use **bind mounts** to expose your application's log directories to Promtail.

> **Why bind mounts instead of symlinks?**
>
> Promtail follows real filesystem paths. Symbolic links can lead to missed log files or inconsistent log discovery, whereas bind mounts present the original directory directly.

Example (Laravel applications):

```sh
sudo mkdir -p /var/log/promtail/app1
sudo mkdir -p /var/log/promtail/app2

sudo mount --bind /var/www/html/app1/storage/logs /var/log/promtail/app1
sudo mount --bind /var/www/html/app2/storage/logs /var/log/promtail/app2
```

Repeat this process for each application whose logs should be collected.

---

## 4. Persist the Bind Mounts

To ensure the bind mounts survive a reboot, add them to `/etc/fstab`.

```fstab
# Promtail log bind mounts
/var/www/html/app1/storage/logs /var/log/promtail/app1 none bind 0 0
/var/www/html/app2/storage/logs /var/log/promtail/app2 none bind 0 0
```

After editing `/etc/fstab`, verify that it is valid:

```sh
sudo mount -a
```

If no errors are returned, the configuration is valid.

---

## 5. Verify the Configuration

Verify that the entries exist in `/etc/fstab`:

```sh
cat /etc/fstab | grep promtail
```

Verify that the bind mounts are active:

```sh
mount | grep promtail
```

Example output:

```text
/var/www/html/app1/storage/logs on /var/log/promtail/app1 type none (bind)
/var/www/html/app2/storage/logs on /var/log/promtail/app2 type none (bind)
```

---

## 6. Restart Promtail

Choose the appropriate restart method depending on the changes made.

| Change | Command |
|---------|---------|
| Promtail configuration changes only | `docker kill --signal=HUP promtail` |
| Docker volumes, bind mounts, or filesystem changes | `docker compose restart promtail` |
| Restart a standalone container | `docker restart promtail` |

---

## Summary

1. Create a centralized log directory.
2. Mount the directory into the Promtail container.
3. Use **bind mounts** to expose each application's log directory.
4. Persist the bind mounts in `/etc/fstab`.
5. Verify the mounts are active.
6. Restart or reload Promtail as needed.

This approach provides a single centralized location (`/var/log/promtail`) from which Promtail can reliably discover and collect logs from multiple applications.
