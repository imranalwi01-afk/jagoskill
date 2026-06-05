FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    curl \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath exif gd intl zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    PHP_EXT_DIR="$(php -r 'echo ini_get("extension_dir");')"; \
    curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o /tmp/ioncube.tar.gz; \
    tar -xzf /tmp/ioncube.tar.gz -C /tmp; \
    cp /tmp/ioncube/ioncube_loader_lin_8.1.so "${PHP_EXT_DIR}/"; \
    echo "zend_extension=${PHP_EXT_DIR}/ioncube_loader_lin_8.1.so" > /usr/local/etc/php/conf.d/00-ioncube.ini; \
    rm -rf /tmp/ioncube /tmp/ioncube.tar.gz

# Prefer IPv4 first to avoid intermittent IPv6/DNS stalls on outbound license checks.
RUN echo "precedence ::ffff:0:0/96 100" >> /etc/gai.conf

COPY docker/php/conf.d/performance.ini /usr/local/etc/php/conf.d/99-performance.ini

COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html
