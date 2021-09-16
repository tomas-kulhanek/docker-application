FROM alpine:3.14.2

LABEL Maintainer="Tomas Kulhanek <jsem@tomaskulhanek.cz>"
LABEL PHP_VERSION="8.0"

# Add application
WORKDIR /var/www/html
# Install packages and remove default server definition
RUN apk --no-cache add \
  curl \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-fpm \
  php8-gd \
  php8-intl \
  php8-json \
  php8-mbstring \
  php8-mysqli \
  php8-opcache \
  php8-openssl \
  php8-session \
  php8-xml \
  php8-xmlreader \
  php8-zlib \
  php8-iconv \
  php8-xmlwriter \
  php8-pdo \
  php8-tokenizer \
  php8-simplexml \
  php8-sodium \
  php8-soap \
  php8-fileinfo && \
  ln -s /usr/bin/php8 /usr/bin/php && \
  mkdir -p /var/www/html && \
  chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini
COPY --chown=nobody src/ /var/www/

USER nobody

EXPOSE 8080
#CMD php-fpm8 -F
#CMD nginx