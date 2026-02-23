# File Upload Size Settings (nginx + PHP 8.3)

## PHP Configuration

Edit `/etc/php/8.3/fpm/php.ini` with these exact lines:

```ini
upload_max_filesize = 1G
post_max_size = 1G
memory_limit = 1G
max_execution_time = 3000
max_input_time = 3000
```

Rules:

post_max_size >= upload_max_filesize
memory_limit > post_max_size

Nginx Configuration
In server/location block of your nginx site config:

```sh
client_max_body_size 1G;
client_body_timeout 300s;
```

Grep Commands (Verify Settings)
```bash
sudo grep -E '^(upload_max_filesize|post_max_size|memory_limit|max_execution_time|max_input_time)' /etc/php/8.3/fpm/php.ini
```
All-in-one with context:

```bash
sudo grep -E '^(upload_max_filesize|post_max_size)' -A2 /etc/php/8.3/fpm/php.ini
```

## Syntax Check

```bash
php -l /etc/php/8.3/fpm/php.ini
```
Success: "No syntax errors detected"
Failure: Shows exact line with syntax error

Apply Changes

```bash
sudo systemctl restart php8.3-fpm nginx
```
Verify in phpMyAdmin
Check Home → Show PHP Information → upload_max_filesize shows 1G (not 2M).

Pro tip: Always run syntax check before restart to avoid silent fallback to 2M defaults.
