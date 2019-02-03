FROM php:7.3-apache

# Install basics 
# (from https://github.com/davidk132/processwire-docker-compose/blob/master/Dockerfile)
RUN apt-get update && apt-get install -y \
    locales \
    libpq-dev \
    libzip-dev \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install intl \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen \
    && locale-gen --no-purge en_US.UTF-8 \
    && echo "LC_ALL=en_US.UTF-8" | tee -a /etc/environment \
    && echo "LANG=en_US.UTF-8" | tee -a /etc/environment

# apache
RUN a2enmod rewrite

ENV PW_VERSION 3.0.123
ENV PW_URL https://github.com/processwire/processwire/archive/${PW_VERSION}.tar.gz
ENV PW_FILE processwire-${PW_VERSION}.tgz

RUN curl -fsSL ${PW_URL} -o ${PW_FILE} \
    && tar -xf ${PW_FILE} --strip-components=1 -C /var/www/html processwire-${PW_VERSION}/wire processwire-${PW_VERSION}/index.php processwire-${PW_VERSION}/htaccess.txt \
    && rm ${PW_FILE} \
    && mv /var/www/html/htaccess.txt /var/www/html/.htaccess

RUN chown -R www-data:www-data /var/www