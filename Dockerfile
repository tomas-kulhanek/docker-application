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
        php7.4-apcu \
        php7.4-apcu-bc \
        php7.4-memcached \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-redis \
        php7.4-amqp \
        php7.4-bcmath \
        php7.4-gd \
        php7.4-imap \
        php7.4-intl \
        php7.4-soap \
        php7.4-xsl \
        php7.4-cli \
        php7.4-curl \
        php7.4-mbstring \
        php7.4-opcache \
        php7.4-readline \
        php7.4-xml \
        php7.4-zip \
        nginx \
        tzdata && \
    rm -f /etc/php/7.4/fpm/pool.d/www.conf && \
    echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    chmod +x /usr/bin/wait-for-it && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/cache/apt/lists

COPY config/php.ini /etc/php/7.4/fpm/conf.d/00-default.ini
COPY config/php.ini /etc/php/7.4/cli/conf.d/00-default.ini
COPY config/php.ini /etc/php/7.4/conf.d/00-default.ini
COPY config/php-pool.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY config/nginx.conf /etc/nginx/nginx.conf


#CMD php-fpm7.4
#CMD nginx
EXPOSE 9000
EXPOSE 8080
