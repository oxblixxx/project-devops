# PHP 8.3 (PHP-FPM) Installation & Troubleshooting on Amazon Linux 2

This document captures the **exact steps, decisions, errors, and fixes** used to successfully install and run **PHP 8.3 with PHP-FPM** on **Amazon Linux 2**, and integrate it with **Apache (httpd)** for a Laravel application.

---

## 1. Initial Problem Statement

* `php-fpm.service` was **not found**
* Default `yum install php-fpm` only offered **PHP 8.0** via Amazon Linux Extras
* Requirement: **Run PHP 8.3** (not available in Amazon Linux Extras)
* Apache was serving **raw PHP source code** instead of executing it

---

## 2. Understanding the Environment

* OS: **Amazon Linux 2**
* Web Server: **Apache (httpd)**
* Application: **Laravel**
* PHP Requirement: **PHP 8.3 + FPM**

Important constraints:

* Amazon Linux Extras **does not provide PHP 8.3**
* PHP 8.3 must be installed from **Remi Repository**

---

## 3. Installing Remi Repository

Amazon Linux 2 is RHEL-compatible, so Remi RPMs can be used.

```bash
sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
```

Enable required repositories:

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --enable remi-php83
```

---

## 4. Installing PHP 8.3 and Extensions

Installed PHP 8.3 using **Software Collections–style packages** (`php83-php-*`).

```bash
sudo yum install -y \
php83-php-fpm \
php83-php-cli \
php83-php-common \
php83-php-mysqlnd \
php83-php-opcache \
php83-php-xml \
php83-php-dom \
php83-php-curl \
php83-php-mbstring \
php83-php-gd \
php83-php-intl \
php83-php-zip
```

📌 Notes:

* PHP binaries are installed under `/opt/remi/php83/`
* Configs live under `/etc/opt/remi/php83/`

---

## 5. Starting and Verifying PHP-FPM 8.3

Start and enable PHP-FPM:

```bash
sudo systemctl enable php83-php-fpm
sudo systemctl start php83-php-fpm
```

Verify status:

```bash
systemctl status php83-php-fpm
```

Confirmed:

* PHP-FPM running
* Master + worker processes active

---

## 6. PHP-FPM Listener Investigation

Checked how PHP-FPM is listening:

```bash
grep -R "^listen" /etc/opt/remi/php83/php-fpm.d/www.conf
```

Result:

```ini
listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1
```

✅ PHP-FPM is listening via **TCP**, not a Unix socket

This explains why:

```bash
ls /var/opt/remi/php83/run/php-fpm/www.sock
```

returned **No such file or directory**

---

## 7. Root Cause of PHP Source Code Being Displayed

Apache was:

* Running correctly
* Serving `.php` files as **plain text**

Root cause:
❌ Apache was **not configured to forward PHP files to PHP-FPM**

---

## 8. Installing Required Apache Modules

Installed missing Apache modules:

```bash
sudo yum install -y httpd mod_proxy mod_proxy_fcgi
```

Enabled and restarted Apache:

```bash
sudo systemctl enable httpd
sudo systemctl restart httpd
```

Verified modules:

```bash
httpd -M | grep -E "proxy|fcgi"
```

Expected output:

```
proxy_module
proxy_fcgi_module
```

---

## 9. Configuring Apache to Use PHP 8.3 FPM

Created FPM handler config:

```bash
sudo nano /etc/httpd/conf.d/php83-fpm.conf
```

Configuration used:

```apache
<IfModule proxy_fcgi_module>
    <FilesMatch \.php$>
        SetHandler "proxy:fcgi://127.0.0.1:9000"
    </FilesMatch>
</IfModule>
```

Restart Apache:

```bash
sudo systemctl restart httpd
```

✅ This step fixed PHP parsing

---

## 10. Laravel VirtualHost Configuration

Correct VirtualHost setup (critical):

```apache
<VirtualHost *:80>
    ServerName example.com
    DocumentRoot /var/www/html/project/public

    <Directory /var/www/html/project/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/project_error.log
    CustomLog /var/log/httpd/project_access.log combined
</VirtualHost>
```

📌 Key points:

* `DocumentRoot` **must point to `/public`**
* `AllowOverride All` is required for Laravel routing

Restart Apache again:

```bash
sudo systemctl restart httpd
```

---

## 11. Rewrite Rules & .htaccess Support

Ensured Apache allows `.htaccess` overrides:

```bash
sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf
sudo systemctl restart httpd
```

---

## 12. Verification & Testing

Created test file:

```bash
echo "<?php phpinfo();" > /var/www/html/project/public/info.php
```

Confirmed in browser:

* PHP Version: **8.3.x**
* SAPI: **FPM/FastCGI**

Laravel application loaded correctly ✅

---

## 13. Key Lessons & Takeaways

* Amazon Linux Extras ≠ latest PHP
* PHP 8.3 requires **Remi repository**
* `php83-php-fpm` runs as a **separate service**
* Apache must explicitly forward `.php` files to FPM
* Raw PHP output = missing `proxy_fcgi` handler

---

## 14. Final State

✅ PHP 8.3 installed
✅ PHP-FPM running
✅ Apache correctly forwarding PHP requests
✅ Laravel working as expected

---

## 15. Recommended Next Steps

* Tune PHP-FPM pool settings (`pm.max_children`, `pm.max_requests`)
* Enable OPcache tuning for production
* Add HTTPS via Certbot or ALB
* Configure SELinux (if enabled)

---

**End of Documentation**
