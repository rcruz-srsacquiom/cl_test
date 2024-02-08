FROM php:7.0-apache as apache

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list
          
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y --no-install-recommends locales g++  wget apt-utils tcl build-essential gnupg2 gnupg -y
RUN curl -O http://ftp.mx.debian.org/debian/pool/main/g/glibc/libc6_2.37-15_amd64.deb && ls -al && dpkg -i libc6_2.37-15_amd64.deb
RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && chmod +x nodesource_setup.sh && ./nodesource_setup.sh && rm nodesource_setup.sh
RUN  cat /etc/apt/sources.list && apt-get install -y nodejs libgconf2-4 libxss1 libbz2-dev wget libcurl4-gnutls-dev libpng-dev libpq-dev libedit-dev libxml2-dev libmemcached-dev libxslt-dev
RUN docker-php-ext-install bz2 calendar exif gd gettext mysqli pcntl pdo_mysql pdo_pgsql pgsql shmop soap sockets sysvmsg sysvsem sysvshm wddx xsl opcache zip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1
RUN pecl channel-update pecl.php.net && pecl install -o -f apcu_bc apcu igbinary memcached msgpack \
    && rm -rf /tmp/pear \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/10-apcu.ini \
    && echo "extension=apc.so" > /usr/local/etc/php/conf.d/apc.ini \
    && echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
    && echo "extension=msgpack.so" > /usr/local/etc/php/conf.d/msgpack.ini



RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod socache_shmcb
RUN a2enmod ssl

WORKDIR /var/www/


EXPOSE 80 443

CMD ["apachectl", "-D", "FOREGROUND"]