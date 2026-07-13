This directory discusses about apache2 setup, securing apache2, and common errors.


To install Apache2 and certbot

```sh
sudo apt install certbot python3-certbot-apache -y
```

Then run below command to get started and setup SSL with already existing `ServerName` in Conf file

```sh
sudo certbot
```

# Resolving an Outdated Certbot Installation on Ubuntu 18.04

Attempting to install certbot on older Ubuntu server would result in an older version of certbot to be installed based on an encounter faced. The following error occurred, and was resolved:

```sh
certbot --apache -d xyz.com
```

>Output
```text
requests.exceptions.ConnectionError:
HTTPSConnectionPool(host='acme-v01.api.letsencrypt.org', port=443):
Max retries exceeded with url: /directory
(Caused by NewConnectionError:
Failed to establish a new connection: [Errno -2] Name or service not known)
```

The error indicated that Certbot was attempting to communicate with the deprecated **ACME v1** Let's Encrypt endpoint (`acme-v01.api.letsencrypt.org`), which is no longer supported. This is commonly caused by an outdated Certbot installation on older Ubuntu/Debian releases.

## Verify Internet Connectivity

Before troubleshooting Certbot, verify that the server has Internet access and working DNS resolution.

```sh
ping -c 4 google.com
ping -c 4 8.8.8.8
```

Successful responses confirm that both network connectivity and DNS resolution are functioning correctly.

## Install the Latest Certbot Using Snap

Since the APT repository on Ubuntu 18.04 provides an outdated version of Certbot, install the latest supported release via Snap.

### Install Snapd

```sh
sudo apt update
sudo apt install snapd -y
```

### Enable and Start the Snap Service

```sh
sudo systemctl enable --now snapd.socket
```

### Install Certbot

```sh
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
```

### Create the Certbot Symlink

```sh
sudo ln -sf /snap/bin/certbot /usr/bin/certbot
```

### Verify the Installation

```sh
certbot --version
```

The installed version should now be the latest available release instead of the outdated package provided by the Ubuntu 18.04 repositories.


So one thing, incase the `domain` is not handled by cloudflare to provide extra layer of security to hide the server public ip address and to avoid users still been able to access the website from the public ip address. Simply Edit the Apache port 80 config:

```sh
sudo nano /etc/apache2/sites-available/000-default.conf
```

Add this:

```sh
<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com

    Redirect permanent / https://yourdomain.com/
</VirtualHost>
```
