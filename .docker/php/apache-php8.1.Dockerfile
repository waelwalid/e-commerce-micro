FROM php:8.1-apache

USER root

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
        libpng-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        zip \
        curl \
        unzip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-source delete

RUN docker-php-ext-install pdo pdo_mysql zip exif \
    && docker-php-ext-enable exif 

# Install PHP extensions
RUN docker-php-ext-configure gd --enable-gd
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# CMD ["/bin/bash", "-c", "cp .env.example .env;chmod -R 777 ./storage;php artisan key:generate;composer install;apache2-foreground;"]