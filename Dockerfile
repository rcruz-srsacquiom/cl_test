FROM php:7.0-apache as apache

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

          
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y libgconf2-4 libxss1 libbz2-dev wget libcurl4-gnutls-dev libpng-dev libpq-dev libedit-dev libxml2-dev libmemcached-dev libxslt-dev
RUN apt-get -y install gnupg ca-certificates apt-transport-https libasound2 libnss3 libgtk-3-0 libxtst6
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*
RUN CHROME_BIN=/usr/bin/google-chrome-stable
RUN docker-php-ext-install bz2 calendar exif gd gettext mysqli pcntl pdo_mysql pdo_pgsql pgsql shmop soap sockets sysvmsg sysvsem sysvshm wddx xsl opcache zip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1
RUN pecl install -o -f apcu_bc apcu igbinary memcached msgpack \
    && rm -rf /tmp/pear \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/10-apcu.ini \
    && echo "extension=apc.so" > /usr/local/etc/php/conf.d/apc.ini \
    && echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && echo "extension=msgpack.so" > /usr/local/etc/php/conf.d/msgpack.ini

RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && chmod +x nodesource_setup.sh && ./nodesource_setup.sh && rm nodesource_setup.sh

RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod socache_shmcb
RUN a2enmod ssl

WORKDIR /var/www/


EXPOSE 80 443

CMD ["apachectl", "-D", "FOREGROUND"]