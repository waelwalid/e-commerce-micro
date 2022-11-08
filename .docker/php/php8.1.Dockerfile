FROM php:8.1-fpm

USER root

# WORKDIR /var/www/html
WORKDIR /var/www

RUN apt-get update && apt-get install -y \
        zlib1g-dev \
        libzip-dev \
        zip \
        unzip \
        build-essential \
        git \
        curl \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libgd-dev \
        jpegoptim optipng pngquant gifsicle \
        libonig-dev \
        libxml2-dev \
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

# COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000
CMD ["php-fpm"]
# RUN chown -R www-data:www-data /var/www/html \
#     && a2enmod rewrite