# vsftpd (Very Secure FTP Daemon) Documentation

## 📌 Overview
**vsftpd** (Very Secure FTP Daemon) is a fast, stable, and security-focused FTP server for Unix-like operating systems.  
It is widely used in production environments for its reliability and robust security features.

---

## 🚀 Features
- 🔒 **Security-first** design (prevents common FTP exploits).
- ⚡ **Lightweight and fast**, even with many connections.
- 📂 **Chroot jail support** (restricts users to their home directories).
- 🔑 **Virtual users** support.
- 🌍 **IPv6 compatibility**.
- 📊 **Bandwidth throttling**.
- 🔐 **SSL/TLS encryption** for secure file transfers.
- 🎛️ **Granular access control** with per-user configuration.

---

## ⚙️ Installation

### On Ubuntu/Debian
```bash
sudo apt update
sudo apt install vsftpd -y
```

Enable and start the service:

```sh
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
```

Take a backup of the conf file.

```sh
cp /etc/vsftpd.conf /etc/backups/vsftpd.conf.bak
```
Then remove the `vsftpd.conf` file and replace with [vsftpd.conf](./vsftpd.conf). 

Create a vsftpd folder, in it create a `user_conf` directory. This is a per-user vsftpd configuration.

```sh
mkdir -p /etc/vsftpd/user_conf
```
Then in `user_conf` directory, create a file with the user name and put atrributes specific to the user in there. For a user [ftpuser](./ftpuser).

```sh
touch /etc/vsftpd/user_conf/ftpuser
```



Currently this vsftpd is setup for multiple users,



