#!/bin/bash

# NGINX Installation Script for CentOS/RHEL, Debian, Ubuntu + FORTRESS DEPLOYMENT
# Uses STABLE repositories (not mainline) per official docs
# https://nginx.org/en/linux_packages.html#Debian
set -e

EXPECTED_FINGERPRINT="573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62"
FORTRESS_FILE="fortress.conf"
TARGET="/etc/nginx/conf.d/fortress.conf"
BACKUP="/etc/nginx/conf.d/fortress.conf.bak"

# ─── MISSING FUNCTIONS ─────────────────────────────────────────────

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            centos|rhel|fedora|rocky|almalinux)
                echo "centos"
                ;;
            debian)
                echo "debian"
                ;;
            ubuntu)
                echo "ubuntu"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    elif [[ -f /etc/redhat-release ]]; then
        echo "centos"
    elif [[ -f /etc/debian_version ]]; then
        if grep -qi ubuntu /etc/os-release 2>/dev/null; then
            echo "ubuntu"
        else
            echo "debian"
        fi
    else
        echo "unknown"
    fi
}

verify_gpg_key() {
    local keyring="$1"
    if ! command -v gpg &>/dev/null; then
        echo "⚠️  gpg not found, skipping GPG fingerprint verification"
        return 0
    fi
    
    local fingerprint
    fingerprint=$(gpg --with-colons --show-keys "$keyring" 2>/dev/null | grep '^fpr' | head -n1 | cut -d: -f10)
    
    if [[ "$fingerprint" == "$EXPECTED_FINGERPRINT" ]]; then
        echo "✅ GPG key fingerprint verified: $fingerprint"
    else
        echo "⚠️  GPG key fingerprint mismatch!"
        echo "   Expected: $EXPECTED_FINGERPRINT"
        echo "   Got:      ${fingerprint:-'(none)'}"
        read -rp "Continue anyway? [y/N]: " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
    fi
}

# ─── PRE-FLIGHT CHECKS ───────────────────────────────────────────────

if [[ $EUID -ne 0 ]]; then
    echo "⚠️  This script requires root privileges. Re-run with sudo."
    exit 1
fi

# Check if NGINX already installed
if command -v nginx &>/dev/null; then
    echo "ℹ️  NGINX already installed: $(nginx -v 2>&1)"
    read -rp "Continue anyway? [y/N]: " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

# Check ports
for port in 80 443; do
    if ss -tlnp | grep -q ":$port "; then
        echo "⚠️  Port $port is already in use:"
        ss -tlnp | grep ":$port "
        read -rp "Continue anyway? [y/N]: " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
    fi
done

# ─── NGINX INSTALLATION ─────────────────────────────────────────────

case "$(detect_os)" in
    centos)
        echo "🛠️  Detected CentOS/RHEL. Installing NGINX Stable..."
        if command -v dnf &>/dev/null; then
            dnf install -y yum-utils
        else
            yum install -y yum-utils
        fi
        
        tee /etc/yum.repos.d/nginx.repo > /dev/null <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=https://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF
        if command -v dnf &>/dev/null; then
            dnf update -y
            dnf install -y nginx
        else
            yum update -y
            yum install -y nginx
        fi
        ;;

    debian)
        echo "🛠️  Detected Debian. Installing NGINX Stable..."
        apt update
        apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
        curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
        verify_gpg_key /usr/share/keyrings/nginx-archive-keyring.gpg
        
        echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://nginx.org/packages/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list > /dev/null
        
        printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx > /dev/null
        apt update
        apt install -y nginx
        ;;

    ubuntu)
        echo "🛠️  Detected Ubuntu. Installing NGINX Stable..."
        apt update
        apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring
        curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
        verify_gpg_key /usr/share/keyrings/nginx-archive-keyring.gpg
        
        echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
https://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list > /dev/null
        
        printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx > /dev/null
        apt update
        apt install -y nginx
        ;;

    *)
        echo "❌ Unsupported OS" >&2
        exit 1
        ;;
esac

echo "🎉 NGINX installed successfully from official stable repository!"

# ─── FORTRESS DEPLOYMENT ────────────────────────────────────────────

echo ""
echo "🚀 Deploying NGINX Global Fortress..."

if [[ ! -f "$FORTRESS_FILE" ]]; then
    echo "⚠️  $FORTRESS_FILE not found in $(pwd). Skipping fortress deployment."
else
    if [[ -f "$TARGET" ]]; then
        echo "📦 Backing up existing $TARGET"
        cp "$TARGET" "$BACKUP"
    fi

    echo "🚀 Copying $FORTRESS_FILE to $TARGET..."
    cp "$FORTRESS_FILE" "$TARGET"
    chown root:root "$TARGET"
    chmod 644 "$TARGET"
fi

# ─── TEST & START ──────────────────────────────────────────────────

echo "🔍 Testing NGINX configuration..."
if nginx -t; then
    echo "✅ NGINX config test PASSED"
    echo "🔄 Starting NGINX service..."
    systemctl enable nginx --now
    echo "📊 NGINX status: $(systemctl is-active nginx)"
    
    echo ""
    echo "🎉 NGINX + GLOBAL FORTRESS deployed successfully!"
    echo ""
    echo "📋 Verify setup:"
    echo "   nginx -t"
    echo "   systemctl status nginx"
    echo "   tail -f /var/log/nginx/access_json.log"
    echo ""
    echo "⚠️  In server/location blocks, add:"
    echo "   limit_req zone=global_rate burst=20 nodelay;"
    echo "   limit_conn global_conn 20;"
    echo "   expires \$expires;"
else
    echo "❌ NGINX config test FAILED"
    if [[ -f "$BACKUP" ]]; then
        echo "💾 Restoring backup from $BACKUP"
        cp "$BACKUP" "$TARGET"
    fi
    exit 1
fi
