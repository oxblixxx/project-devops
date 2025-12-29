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
