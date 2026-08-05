#!/bin/bash
set -e

# Define PHP version (pass it as first argument, or fallback to default)
PHP_VERSION=${1:-"8.3"}

echo "Installing PHP $PHP_VERSION on Ubuntu/Debian for NGINX..."

sleep 2

# Update system
sudo apt update -y

# Add Ondřej Surý PPA (for multiple PHP versions)
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update -y

# Install PHP, PHP-FPM and common extensions
sudo apt install -y \
    php$PHP_VERSION \
    php$PHP_VERSION-fpm \
    php$PHP_VERSION-cli \
    php$PHP_VERSION-common \
    php$PHP_VERSION-bcmath \
    php$PHP_VERSION-mbstring \
    php$PHP_VERSION-xml \
    php$PHP_VERSION-zip \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-curl \
    php$PHP_VERSION-intl \
    php$PHP_VERSION-imap \
    php$PHP_VERSION-mysql \
    php$PHP_VERSION-xsl \
    php$PHP_VERSION-exif \
    php$PHP_VERSION-sqlite3

# Enable and start PHP-FPM
sudo systemctl enable php$PHP_VERSION-fpm
sudo systemctl restart php$PHP_VERSION-fpm

# Restart NGINX if installed
if systemctl list-unit-files | grep -q "^nginx.service"; then
    sudo systemctl restart nginx
fi

sleep 2

# Verify installation
echo ""
echo "PHP Version:"
php -v

echo ""
echo "PHP-FPM Status:"
systemctl --no-pager --full status php$PHP_VERSION-fpm
