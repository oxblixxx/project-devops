# 🚀 Setting up vsftpd(Very Secure FTP Daemon) for Users access into a Restricted Directory
vsftpd is a lightweight, secure, and stable FTP server.

 - Installation
 - User Creation
---

# ⚙️ Installation
To set up vsftpd on Debian or Ubuntu, follow these steps:

First, update your package list and install the daemon.

```sh
sudo apt update
sudo apt install vsftpd -y
```

Enable and start the vsftpd service to ensure it launches automatically at boot.

```sh
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
```

Back up the default configuration file, then replace it with your custom one. This prevents losing your original settings.

```sh
cp /etc/vsftpd.conf /etc/backups/vsftpd.conf.bak
sudo rm /etc/vsftpd.conf
```

Create a `vsftpd.conf` file with this contents [vsftpd.conf](./vsftpd.conf). Replace the `passv_address` with your public-ipaddress.

```sh
sed -i 's/^pasv_address=.*/pasv_address=203.0.113.25/' /etc/vsftpd.conf
```

Create a directory for per-user configuration files. This allows you to apply specific rules to individual users.

```sh
sudo mkdir -p /etc/vsftpd/user_conf
```

# 👥 User Creation
To create a new, secure FTP user locked to their home directory, follow this process:

Add a new user named ftpuser with a restricted bash shell (/bin/rbash). This prevents them from executing arbitrary commands. The -m flag creates the user's home directory.

NB:::: THERE IS AN ISSUE, NOT FIXED YET, CREATE USER WITH A /bin/bash shell
```sh
sudo useradd -m -d /home/ftpuser -s /bin/rbash ftpuser
sudo passwd ftpuser
```

Create a user-specific configuration file within the user_conf directory. This file will contain attributes that override the global settings for ftpuser, such as locking them into a specified directory.

```sh
sudo touch /etc/vsftpd/user_conf/ftpuser
```
Replace with this contents [ftpuser](./ftpuser)

Once the user is created, they can log in using an FTP client like FileZilla. They will be chrooted, or locked, to the specified directory, restricting their access to the rest of the file system.
sudo touch /etc/vsftpd/user_conf/ftpuser
Once the user is created, they can log in using an FTP client like FileZilla. They will be chrooted, or locked, to their home directory, restricting their access to the rest of the file system.
