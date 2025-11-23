# Apache2 Fortress on Ubuntu

This document is my reference for hardening Apache on Ubuntu. It’s written so that future‑me (and anyone else) can quickly follow the steps, understand why they exist, and tweak them when needed.

---

## Goals

- Stop Apache from exposing its exact version and OS in responses.  
- Add a sane baseline of security headers.  
- Optionally enable CORS and ModSecurity, with clear warnings where things are “sharp knives”.

---

## 1. Hide Apache version and signature

Apache loves to tell the world what it’s running; this tones that down.

### 1.1 Enable the security config
```sh
sudo a2enconf security
sudo systemctl restart apache2
```

### 1.2 Tighten `ServerTokens` and `ServerSignature`

Edit the security config:

```sh
sudo nano /etc/apache2/conf-available/security.conf
```

Make sure these are present (and not overridden later):

```sh
ServerTokens Prod # Setting this will only show Apache as server name
ServerTokens Full # Setting this needs other configuration to be done below to choose a customname 
ServerSignature Off # Hides version on error pages / directory listings
```
Restart to apply:

```sh
sudo systemctl restart apache2
```

At this point, the `Server:` header should no longer look like `Apache/2.4.63 (Ubuntu)`.

---

## 2. Baseline security headers

These headers reduce information leakage and add basic browser‑side protections.

### 2.1 Add headers to `security.conf`

Edit the same file:

sudo nano /etc/apache2/conf-available/security.conf

```sh
Prevent MIME sniffing
Header always set X-Content-Type-Options "nosniff"

Clickjacking protection
Header always set X-Frame-Options "DENY"

XSS protection (legacy browsers)
Header always set X-XSS-Protection "1; mode=block"

Referrer policy (limit cross-site leakage)
Header always set Referrer-Policy "strict-origin-when-cross-origin"

Prevent old Flash / cross-domain policies
Header always set X-Permitted-Cross-Domain-Policies "none"

Remove tech details if something sets them
Header always unset X-Powered-By

HSTS (ONLY enable when HTTPS is fully working and permanent)
Forces HTTPS for 1 year and applies to subdomains
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
Permissions Policy (formerly Feature-Policy)
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=(), fullscreen=(self)"

Content Security Policy (CSP)
NOTE: This is strict. Expect to tweak for real apps (CDNs, analytics, etc).
Header always set Content-Security-Policy "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdnjs.cloudflare.com https://cdn.jsdelivr.net https://stackpath.bootstrapcdn.com; font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com https://cdn.jsdelivr.net https://stackpath.bootstrapcdn.com https://code.jquery.com;"
#Header always set Content-Security-Policy "default-src 'self'; img-src 'self' data:; script-src 'self'; style-src 'self' 'unsafe-inline'; frame-ancestors 'none'"
```

### 2.2 Make sure headers module is enabled

```sh
sudo a2enmod headers
sudo systemctl reload apache2
```
---

## 3. (Optional) CORS configuration

This section is only for situations where cross‑origin access is actually needed (APIs, frontends on a different origin, etc.).  
If in doubt, **skip this**; `*` is very permissive.

Edit the main Apache config:

```sh
sudo nano /etc/apache2/apache2.conf
```
Add:

```sh
Very permissive CORS – only enable if the app truly needs cross-origin access
Header always set Access-Control-Allow-Origin "*"
Header always set Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE"
Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
```
Then:

```sh
sudo systemctl restart apache2
```

If/when tightening this later, replace `"*"` with specific origins and trim the methods/headers list.

---

## 4. (Optional) ModSecurity and custom server signature

ModSecurity adds a WAF layer and also gives more control over how the server identifies itself, If `ServerToken` is set to `Full`, Then this must be done.

### 4.1 Install and enable ModSecurity

```sh
sudo apt install libapache2-mod-security2
sudo a2enmod security2
sudo systemctl restart apache2
```

At this point, ModSecurity is loaded with its default config (rules are a separate topic; this doc is mostly about the signature and basics).

### 4.2 Override the server signature via ModSecurity

Create a tiny config file:

sudo nano /etc/modsecurity/hide_server_tokens.conf
Add:

```sh
SecServerSignature "MomSaidNoHackingAllowed"
```

Now include this file from Apache’s main config:

```sh
sudo nano /etc/apache2/apache2.conf
```

Add:

```sh
IncludeOptional /etc/modsecurity/hide_server_tokens.conf
```

Restart Apache:

```sh
sudo systemctl restart apache2
```

From here on, Apache’s signature should be replaced with the custom string above (subject to how the client inspects headers).

---

## 5. Verification checklist

Quick checks for future‑me:

- `curl -I https://your-domain`  
  - `Server:` should not show `Apache/x.y.z (Ubuntu)` anymore.  
  - Security headers like `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, etc., should be present.  
- If HSTS is enabled, `Strict-Transport-Security` should be visible on HTTPS responses.  
- If CORS is enabled, `Access-Control-Allow-*` headers should appear where expected.  
- If ModSecurity signature override is in place, confirm the custom string is visible where applicable.

```sh
HTTP/1.1 301 Moved Permanently
Date: Sun, 23 Nov 2025 02:13:35 GMT
Server: AdminSaidNoHackingAllowed
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
X-Permitted-Cross-Domain-Policies: none
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
Permissions-Policy: geolocation=(), microphone=(), camera=(), fullscreen=(self)
Content-Security-Policy: default-src 'self'; img-src 'self' data:; script-src 'self'; style-src 'self' 'unsafe-inline'; frame-ancestors 'none'
Location: https://txxx.apxxxx.com/
Content-Type: text/html; charset=iso-8859-1
```

---
