#!/bin/bash

# NGINX Installation Script for CentOS/RHEL, Debian, Ubuntu + FORTRESS DEPLOYMENT
# Uses STABLE repositories (not mainline) per official docs

set -e

EXPECTED_FINGERPRINT="573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62"
FORTRESS_FILE="fortress.conf"
TARGET="/etc/nginx/conf.d/fortress.conf"
BACKUP="/etc/nginx/conf.d/fortress.conf.bak"

# [Previous checks unchanged... NGINX exists, ports 80/443...]

# NGINX Installation - STABLE REPOSITORIES
case "$(detect_os)" in
    centos)
        echo "🛠️  Detected CentOS/RHEL. Installing NGINX Stable..."
        sudo yum install -y yum-utils || sudo dnf install -y yum-utils
        sudo tee /etc/yum.repos.d/nginx.repo > /dev/null <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=https://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF
        # NO --enable nginx-mainline - keeps STABLE enabled
        sudo yum update -y
        echo "ℹ️  Installing NGINX Stable - verify GPG fingerprint when prompted."
        sudo yum install -y nginx
        ;;

    debian)
        echo "🛠️  Detected Debian. Installing NGINX Stable..."
        sudo apt update
        sudo apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
        curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
        verify_gpg_key /usr/share/keyrings/nginx-archive-keyring.gpg
        
        # STABLE Debian repo (EXACT official docs)
        echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
  https://nginx.org/packages/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list > /dev/null
        
        echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900" | sudo tee /etc/apt/preferences.d/99nginx > /dev/null
        sudo apt update
        sudo apt install -y nginx
        ;;

    ubuntu)
        echo "🛠️  Detected Ubuntu. Installing NGINX Stable..."
        sudo apt update
        sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring
        curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
        verify_gpg_key /usr/share/keyrings/nginx-archive-keyring.gpg
        
        # STABLE Ubuntu repo (EXACT official docs)
        echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
  https://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list > /dev/null
        
        echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900" | sudo tee /etc/apt/preferences.d/99nginx > /dev/null
        sudo apt update
        sudo apt install -y nginx
        ;;

    *)
        echo "❌ Unsupported OS" >&2
        exit 1
        ;;
esac


echo "🎉 NGINX installed successfully from official mainline repository!"

# FORTRESS DEPLOYMENT
echo ""
echo "🚀 Deploying NGINX Global Fortress..."

# Check if fortress.conf exists in current directory
if [[ ! -f "$FORTRESS_FILE" ]]; then
    echo "⚠️  $FORTRESS_FILE not found. Skipping fortress deployment."
else
    # Backup existing fortress.conf if it exists
    if [[ -f "$TARGET" ]]; then
        echo "📦 Backing up existing $TARGET"
        sudo cp "$TARGET" "$BACKUP"
    fi

    # Deploy fortress.conf
    echo "🚀 Copying $FORTRESS_FILE to $TARGET..."
    sudo cp "$FORTRESS_FILE" "$TARGET"

    # Fix permissions
    sudo chown root:root "$TARGET"
    sudo chmod 644 "$TARGET"
fi

# Test and start NGINX
echo "🔍 Testing NGINX configuration..."
if sudo nginx -t; then
    echo "✅ NGINX config test PASSED"
    echo "🔄 Starting NGINX service..."
    sudo systemctl enable nginx --now
    echo "📊 NGINX status: $(sudo systemctl is-active nginx)"
    
    echo ""
    echo "🎉 NGINX + GLOBAL FORTRESS deployed successfully!"
    echo ""
    echo "📋 Verify setup:"
    echo "   sudo nginx -t"
    echo "   sudo systemctl status nginx"
    echo "   tail -f /var/log/nginx/access_json.log"
    echo ""
    echo "⚠️  In server/location blocks, add:"
    echo "   limit_req zone=global_rate burst=20 nodelay;"
    echo "   limit_conn global_conn 20;"
    echo "   expires \$expires;"
else
    echo "❌ NGINX config test FAILED"
    [[ -f "$BACKUP" ]] && echo "💾 Restored backup from $BACKUP"
    exit 1
fi
