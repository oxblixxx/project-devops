# Laravel Docker 500 Error Fix Documentation

## Problem

**Access logs when domain is hit:**
GET /index.php → 500 Internal Server Error

**Direct PHP execution error (`docker exec app php /var/www/public/index.php`):**
```php
In StreamHandler.php line 156:
The stream or file "/var/www/storage/logs/laravel.log" could not be opened
in append mode: Failed to open stream: Permission denied
The exception occurred while attempting to log: The stream or file "/var/ww
w/storage/logs/laravel.log" could not be opened in append mode: Failed to o
pen stream: Permission denied
The exception occurred while attempting to log: PreventIframeEmbedding Midd
leware executed.
Context: {"exception":{}}
```
## Root Cause

Docker volume-mounted `/var/www/storage/logs/laravel.log` owned by **root**, PHP-FPM runs as **www-data** → can't write logs → Laravel crashes with 500 error.

## Fix Commands (Run in Order)

### 1. Get container names
docker ps

text

### 2. Fix permissions (CRITICAL)
docker exec -u root app chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
docker exec -u root app chmod -R 775 /var/www/storage /var/www/bootstrap/cache

text

### 3. Verify fix
docker exec app php /var/www/public/index.php # No errors
curl -I http://napp namen # 200 OK
docker logs app # Clean logs



## PHP Session Configuration Override – Root Cause & Resolution
### Problem Summary
The application was throwing:

```php
As per phpinfo() from browser, the web server configuration shows:
session.save_path (Local Value): /var/cpanel/php/sessions/ea-php82
session.save_path (Master Value): /var/lib/php/sessions
Since the application runs via web server, it follows the Local Value.
We are not setting any custom session path in code.
Kindly align the web PHP configuration to use /var/lib/php/sessions
or ensure /var/cpanel/php/sessions/ea-php82 exists with proper permissions.
Hardcoding a session path in code is not recommended for portability.
```

Details fetched from creating a From phpinfo(): showed this:

```php
session.save_path (Local Value)  => /var/cpanel/php/sessions/ea-php82
session.save_path (Master Value) => /var/lib/php/sessions
```
This indicates that the runtime configuration (Local Value) differs from the system default (Master Value).

2️⃣ Understanding PHP Configuration Layers

PHP configuration can be set in multiple places. These layers have different priorities.

A. Global PHP Configuration

- File:

```sh
/etc/php/8.3/fpm/php.ini
```

This is the system-wide default configuration used by PHP-FPM.

It defines:

```php
session.save_path
memory limits
upload limits
error settings
```

This produces the Master Value shown in phpinfo().

B. PHP-FPM Pool Configuration (Optional Layer)

Files:

```php
/etc/php/8.3/fpm/pool.d/*.conf
```
Can override settings using:

```php
php_value
php_admin_value
```

Overrides global php.ini for that pool.

C. Project-Level php.ini

Example:

/var/www/html/phpproject/web/php.ini

This file applies only to that directory (and subdirectories).

If it contains:

```php
session.save_path = "/custom/path"
```
It overrides the global configuration.

D. .user.ini (Very Important)

Example:

```sh
/var/www/html/phpproject/web/.user.ini
```
.user.ini files:

Are directory-based overrides

Are scanned automatically by PHP

Apply only to that directory tree

>Have higher priority than global php.ini

They are commonly used in shared hosting (like cPanel).

3️⃣ Configuration Priority (Highest → Lowest)

- ini_set() inside PHP code
- .user.ini
- Project-level php.ini
- PHP-FPM pool config (php_value)
- Global /etc/php/8.3/fpm/php.ini

So even if the system config is correct, a project-level override will win.

4️⃣ Root Cause in This Case

Found via:

```sh
grep -R session.save_path /var/www/html/phpproject/
```
Result:

```php
phpproject/web/php.ini:
session.save_path = "/var/cpanel/php/sessions/ea-php82"
phpproject/web/.user.ini:
session.save_path = "/var/cpanel/php/sessions/ea-php82"
```

5️⃣ Why phpinfo() Showed Different Values

In phpinfo():

```php
Master Value  => System-level default
Local Value   => Effective runtime value
```

Since project files overrode the global config, the Local Value was different.

6️⃣ Debugging Methodology (Correct Approach)

Step-by-step process used:

1️⃣ Check phpinfo()

Confirm mismatch between Local and Master.

2️⃣ Check global config

> grep session.save_path /etc/php/8.3/fpm/php.ini
3️⃣ Check FPM pool config
> grep -R php_value /etc/php/8.3/fpm/pool.d/
4️⃣ Check project directory
> grep -R session.save_path .

This revealed the override files.

This is the correct structured debugging approach.

7️⃣ Resolution

Replaced/Remove:

```php
session.save_path = "/var/cpanel/php/sessions/ea-php82" > session.save_path = "/var/lib/php/sessions"
```
From:

```php
phpproject/web/php.ini
```
```php
phpproject/web/.user.ini
```

Restarted:

```sh
systemctl restart php8.3-fpm
systemctl reload nginx
```
After restart, the phpconf showed this:

```sh
Local Value  => /var/lib/php/sessions
Master Value => /var/lib/php/sessions
```
