# Use the official PHP image as the base image
# THIS DOCKERFILE IS USED TO DOCKERIZE THE LARAVEL APPLICATION 
FROM php:8.2-fpm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    git \
    libpng-dev \
    libjpeg62-turbo-dev \  
    libwebp-dev \          
    libxpm-dev \           
    libonig-dev \
    libxml2-dev \
    ffmpeg \
    zlib1g-dev \
    libzip-dev \
    && docker-php-ext-configure gd \
        --with-jpeg \
        --with-webp \
        --enable-gd \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip


# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Create a new system user for running the Laravel app
RUN useradd -ms /bin/bash laravel

# Set the working directory
WORKDIR /var/www/html

# Copy Laravel app code to the container
COPY . .

# Change ownership of the working directory to the Laravel user
RUN chown -R laravel:laravel /var/www/html
RUN chmod -R 775 /var/www/html
#RUN chmod -R 777 /var/www/public/storage

# Switch to the Laravel user
USER laravel

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
EXPOSE 80