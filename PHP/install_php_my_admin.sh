#!/bin/bash
set -e

echo "=== Installing phpMyAdmin ==="

# Update package list
sudo apt update -y

# Install phpMyAdmin and dependencies
sudo apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl

# Link phpMyAdmin Apache config (if not already linked)
if [ ! -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
    sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
fi

# Enable phpMyAdmin config
sudo a2enconf phpmyadmin

# Enable required PHP extensions
sudo phpenmod mysqli mbstring

# Reload Apache to apply changes
sudo systemctl reload apache2

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "=== phpMyAdmin installation completed successfully ==="
echo "Access phpMyAdmin at: http://$SERVER_IP/phpmyadmin"
