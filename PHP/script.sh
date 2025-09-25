#!/bin/bash
set -e

# Define PHP version (pass it as first argument, or fallback to default)
PHP_VERSION=${1:-"8.3"}

echo "Installing PHP $PHP_VERSION on Ubuntu/Debian..."

# Update system
sudo apt update -y

# Add Ondřej Surý PPA (for multiple PHP versions)
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update -y

# Install PHP and common extensions
sudo apt install -y php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-common \
    php$PHP_VERSION-bcmath php$PHP_VERSION-mbstring php$PHP_VERSION-xml \
    php$PHP_VERSION-zip php$PHP_VERSION-gd php$PHP_VERSION-curl \
    php$PHP_VERSION-intl php$PHP_VERSION-imap php$PHP_VERSION-mysql \
    php$PHP_VERSION-xsl php$PHP_VERSION-exif php$PHP_VERSION-sqlite3 \
    php$PHP_VERSION-gettext

sudo apt install -y libapache2-mod-php$PHP_VERSION
# DISMOD PREVIOUSLY INSTALLED PHP VERSION
#sudo a2dismod php8.2
sudo a2enmod php$PHP_VERSION
sudo systemctl restart apache2

# Verify installation
php -v
