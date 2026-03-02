## Permission Fix for Grafana Docker Data Directory Docker Setup
Here is what the complete error from the docker log looks like
> "GF_PATHS_DATA='/var/lib/grafana' is not writable.
You may have issues with file permissions, more information here: http://docs.grafana.org/installation/docker/#migrate-to-v51-or-later.
mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied.
GF_PATHS_DATA='/var/lib/grafana' is not writable.
You may have issues with file permissions, more information here: http://docs.grafana.org/installation/docker/#migrate-to-v51-or-later.
mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied.
GF_PATHS_DATA='/var/lib/grafana' is not writable.
mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied.
You may have issues with file permissions, more information here: http://docs.grafana.org/installation/docker/#migrate-to-v51-or-later.
GF_PATHS_DATA='/var/lib/grafana' is not writable.
You may have issues with file permissions, more information here: http://docs.grafana.org/installation/docker/#migrate-to-v51-or-later.
mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied".
This error is coming from Grafana running in Docker, and it means:

> The container user does not have permission to write to `/var/lib/grafana`.

This usually happens when a host directory is mounted into the container and the ownership doesn’t match the Grafana user inside the container.

---

##  Why This Happens

Grafana Docker runs as:

```sh
UID 472
GID 472
```

If the host directory is owned by `root` (or another user), Grafana can’t write to it.

---

## ✅ Fix

If Docker is used with a bind mount like this:

```bash
-v /your/host/grafana-data:/var/lib/grafana
```
or in a docker-compose.yml setup:

```sh
volumes:
  - ./grafana-data:/var/lib/grafana
```

Fix permissions on the host:

```sh
sudo chown -R 472:472 /your/host/grafana-data
```
