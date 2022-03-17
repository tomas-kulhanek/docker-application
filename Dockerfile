FROM ubuntu:20.04

LABEL maintainer="Tomas Kulhanek <jsem@tomaskulhanek.cz>"
# Fixes some weird terminal issues such as broken clear / CTRL+L
ENV TERM=linux
ENV TZ 'Europe/Prague'
# Ensure apt doesn't ask questions when installing stuff
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www

COPY wait-for-it.sh /usr/bin/wait-for-it
RUN apt-get -y --no-install-recommends update \
    && apt-get install -y --no-install-recommends gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-php.list \
    && echo "deb http://archive.ubuntu.com/ubuntu bionic main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu bionic-security main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main multiverse restricted universe" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get -y --no-install-recommends update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        unzip \
        php-apcu \
        php-apcu-bc \
        php-memcached \
        php8.1-fpm \
        php8.1-mysql \
        php-redis \
        php8.1-amqp \
        php8.1-bcmath \
        php8.1-gd \
        php8.1-imap \
        php8.1-intl \
        php8.1-soap \
        php8.1-xsl \
        php8.1-cli \
        php8.1-curl \
        php8.1-mbstring \
        php8.1-opcache \
        php8.1-readline \
        php8.1-xml \
        php8.1-zip \
        nginx \
        tzdata && \
    rm -f /etc/php/8.1/fpm/pool.d/www.conf && \
    echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    chmod +x /usr/bin/wait-for-it && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/cache/apt/lists

COPY config/php.ini /etc/php/8.1/fpm/conf.d/00-default.ini
COPY config/php.ini /etc/php/8.1/cli/conf.d/00-default.ini
COPY config/php.ini /etc/php/8.1/conf.d/00-default.ini
COPY config/php-pool.conf /etc/php/8.1/fpm/pool.d/www.conf
COPY config/nginx.conf /etc/nginx/nginx.conf


#CMD php-fpm8.1
#CMD nginx
EXPOSE 9000
EXPOSE 8080
