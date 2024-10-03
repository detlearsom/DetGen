FROM php:7.2-apache

# Update package lists and install required dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        rsyslog procps \
        && \
    rm -rf /var/lib/apt/lists/*

# Install mysqli extension
RUN docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli

# Expose port 80 for Apache
EXPOSE 80

