# teyc/concrete5:8
FROM php:7.3.19-fpm-alpine3.12

ENV \
  ADMINER_VERSION=4.7.7 \
  MYSQL_DATABASE=concrete5 \
  MYSQL_USER=c5_user \
  MYSQL_PASSWORD=c5_password

RUN \
  # install
  apk add -U --no-cache \
    mysql mysql-client \
    nano \
    nginx \
    supervisor \
    php7-pdo_mysql \
    php7-gd \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    libzip-dev zlib-dev \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd pdo pdo_mysql zip \
  # concrete5
  && curl -sSLo /var/tmp/concrete5-8.5.4.zip https://www.concrete5.org/download_file/-/view/113632/ \
  && unzip /var/tmp/concrete5-8.5.4.zip -d /var/tmp/ \
  && mv /var/tmp/concrete5-8.5.4/* /var/www/html/ \
  # adminer
  && mkdir -p /var/www/adminer \
    && curl -sSLo /var/www/adminer/index.php \
      "https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION-en.php" \
  # cleanup
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

# nginx config
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# supervisor config
COPY \
  mysql/mysqld.ini \
  nginx/nginx.ini \
  php/php-fpm.ini \
  /etc/supervisor.d/

# entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# ports
EXPOSE 3306 88 80

# commands
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n", "-j", "/supervisord.pid"]
