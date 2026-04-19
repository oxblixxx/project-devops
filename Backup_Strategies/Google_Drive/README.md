# Google Drive Backup Setup + Rclone + MSMTP

This setup uses Google Drive as a remote storage backend for backups via rclone.

## Overview

Google Drive provides a simple and accessible cloud storage solution that integrates easily with rclone for automated backups and file synchronization. A standard Google account (Gmail) comes with 15 GB of free storage, which can be used to store backups, logs, and other important files.

## Requirements
- A Gmail account
- rclone installed on your system
- Google Drive
- Gmail

To ensure your backup storage is safe:

- Enable 2FA (Two-Factor Authentication) on your Gmail account
- Use a strong, unique password
- Regularly review account activity

```Disclaimer```
This setup is suitable and small-scale backups. For production environments, consider more robust and scalable storage solutions.
