# Vaultwarden Setup & Administration Guide
*Compiled from troubleshooting session — covers SMTP, domains, organizations, security, and upgrades.*

---

## Table of Contents

1. [SMTP Configuration](#1-smtp-configuration)
2. [Domain & URL Configuration](#2-domain--url-configuration)
3. [Organization Management](#3-organization-management)
4. [Security Hardening](#4-security-hardening)
5. [Upgrading Vaultwarden](#5-upgrading-vaultwarden)
6. [Official Resources](#6-official-resources)

---

## 1. SMTP Configuration

### 1.1 SMTP Host vs. SMTP Username

| Field | Purpose | Example |
|---|---|---|
| **SMTP Host** | The mail server address | `smtp.gmail.com` |
| **SMTP Username** | Your login credential | `you@gmail.com` |
| **SMTP Password** | Your authentication secret | App Password (not your Google password) |

The **host** tells Vaultwarden *where* to connect. The **username** tells the server *who* is connecting. They are not interchangeable.

### 1.2 "No compatible authentication mechanism was found"

This error means Vaultwarden's SMTP client and your mail server cannot agree on an authentication method.

**Common causes and fixes:**

| Cause | Fix |
|---|---|
| **SMTP_SECURITY=off** | Change to `starttls` (port 587) or `force_tls` (port 465). Gmail and most providers refuse unencrypted auth. |

### 1.3 Gmail-Specific Settings

```yaml
SMTP_HOST: smtp.gmail.com
SMTP_PORT: 587
SMTP_SECURITY: starttls
SMTP_USERNAME: you@gmail.com
SMTP_PASSWORD: <16-character-app-password>
SMTP_AUTH_MECHANISM:          # leave blank for auto-detect
```

**Critical:** You must use a **Gmail App Password**, not your regular Google account password. Generate one at: Google Account → Security → 2-Step Verification → App passwords.

---

## 2. Domain & URL Configuration

### 2.1 Fixing "localhost" Redirects

If invitation links or organization acceptance URLs redirect to `http://localhost/#/...`, Vaultwarden does not know its public URL.

**Fix:** Set the `DOMAIN` environment variable to your full public URL, including `https://`:

```yaml
DOMAIN: https://vault.yourdomain.com
```

**Rules:**
- Include the scheme (`https://`)
- **No trailing slash**
- This affects: invitation emails, organization join links, emergency access invites, and some 2FA flows

---

## 3. Organization Management

### 3.1 Fingerprint Phrase Verification

When confirming a user into your organization, Vaultwarden displays a **fingerprint phrase** — a human-readable representation of that user's public encryption key.

**Why it matters:** It protects against man-in-the-middle attacks. If an attacker substituted their own key during the invitation process, you would be encrypting organization secrets for them.

**How to verify:**
1. You (the admin) see the fingerprint phrase on the "Confirm user" screen
2. The new user opens their client → **Settings → My Account** and views their own fingerprint phrase
3. Compare out-of-band (in person, phone, secure message)
4. **Match?** Click confirm. **Don't match?** Reject and investigate.

### 3.2 Collection Access Behavior

- Granting a user access to a collection gives them access to **ALL** items in that collection — both pre-existing and new
- There is **no** "only show items created after I joined" option
- **Read-only** and **Hide passwords** permissions control editing and password visibility, but not item existence

**To hide old items from a new user:**
- Create a **new collection** and move only the items you want them to see into it
- Or move sensitive legacy items into an admin-only collection

---

## 4. Security Hardening

### 4.1 IP Restrictions: What They Do and Don't Do

IP restriction reduces attack surface but is **not** a guarantee.

**What it stops:** Random internet scans, opportunistic attackers, most bot traffic.

**What it does NOT stop:**

| Threat | How it bypasses IP restriction |
|---|---|
| Compromised allowed device | Attacker inherits the trusted IP |
| VPN/Proxy hijacking | Stealing proxy credentials grants allowed-IP access |
| Reverse proxy misconfiguration | Spoofing `X-Forwarded-For` headers |
| Application vulnerabilities | RCE or auth bypass bugs in Vaultwarden itself |
| DNS rebinding | Tricking a browser inside the allowed network |
| Insider threat / lateral movement | Malware already inside the network attacks freely |
| Dynamic IP reassignment | Your old IP recycled to someone else |

### 4.2 Defense in Depth

Layer these protections **in addition to** IP restriction:

1. **Enforce 2FA/FIDO2** for all accounts, especially admin
2. **Lock down `/admin`** behind a separate auth layer (Authelia, Authentik, or basic auth)

---

## 5. Upgrading Vaultwarden

### 5.1 Pre-Upgrade: Always Back Up

```bash
# Stop the container first for data consistency
docker compose down

# Back up the entire data directory
sudo cp -a /path/to/vaultwarden-data /path/to/vaultwarden-data-backup-$(date +%Y%m%d)
```

### 5.2 Standard Upgrade (Docker Compose)

```bash
# 1. Update the image tag in docker-compose.yml
#    e.g., image: vaultwarden/server:1.37.1

# 2. Pull the new image
docker compose pull

# 3. Recreate the container
docker compose up -d

# 4. Verify
docker compose ps
docker compose logs -f
```

### 5.3 Skipping Versions

**You can jump directly across versions.** Vaultwarden applies all missing database migrations automatically on first start.

**Database backend matters:**

| Backend | Risk |
|---|---|
| **SQLite** (default) | **Lowest risk.** Most widely tested. Direct jumps are safe. |
| **MariaDB / MySQL** | **Higher risk.** Documented migration failures (foreign key constraints, charset mismatches, SSO table issues) when skipping versions. Consider staging: `1.32.5` → `1.35.0` → `1.37.1`. |

### 5.4 Rollback (If Something Breaks)

```bash
docker compose down

# Restore data from backup
sudo rm -rf /path/to/vaultwarden-data/*
sudo cp -a /path/to/vaultwarden-data-backup-YYYYMMDD/. /path/to/vaultwarden-data/

# Revert docker-compose.yml to previous image tag
docker compose up -d
```

### 5.5 Post-Upgrade Checklist

- [ ] Container starts without restart loops
- [ ] Logs show successful migrations (if applicable)
- [ ] You can log in and unlock your vault
- [ ] Organization/collections are intact
- [ ] Admin panel loads (if enabled)
- [ ] Clean up old images: `docker image prune -f`

---

## 6. Official Resources

| Resource | URL |
|---|---|
| **GitHub Repository** | https://github.com/dani-garcia/vaultwarden |
| **Wiki (primary docs)** | https://github.com/dani-garcia/vaultwarden/wiki |
| **Environment Variables** | `.env.template` in the repo root |
| **Docker Hub** | https://hub.docker.com/r/vaultwarden/server |
| **GitHub Discussions** | https://github.com/dani-garcia/vaultwarden/discussions |
| **Issue Tracker** | https://github.com/dani-garcia/vaultwarden/issues |

> **Note:** Vaultwarden is an independent community project. Do not use official Bitwarden support channels for Vaultwarden-specific issues.

---

*Document generated from troubleshooting session covering versions 1.32.5 through 1.37.1.*
