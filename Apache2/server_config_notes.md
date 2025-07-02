# Apache Redirect Configuration

## Table of Contents
- [Redirect `www.zzzz.com` → `zzzz.com`](#apache-redirect-wwwzzzzcom--zzzzcom)

# Apache Redirect: `www.zzzz.com` → `zzzz.com`
Ensure to change the ServerAlias to www.zzz.com. Then modify the server block as shown below

## 1. HTTP (Port 80) - Redirect to HTTPS + non-www
```apache
<VirtualHost *:80>
    ServerName zzzz.com
    ServerAlias www.zzzz.com

    # Force HTTPS and non-www
    RewriteEngine On
    RewriteCond %{HTTPS} off [OR]
    RewriteCond %{HTTP_HOST} ^www\.zzzz\.com [NC]
    RewriteRule ^(.*)$ https://zzzz.com/$1 [L,R=301]
</VirtualHost>
```
2. HTTPS (Port 443) - Remove www
```apache
<VirtualHost *:443>
    ServerName zzzz.com
    ServerAlias www.zzzz.com

    # Remove www (HTTPS only)
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.zzzz\.com [NC]
    RewriteRule ^(.*)$ https://zzzz.com/$1 [L,R=301]
</VirtualHost>
```
Key Notes:
Placement: Add these rules inside the respective <VirtualHost> blocks.
Testing: Use curl -I http://zzzz.com to verify redirects.
