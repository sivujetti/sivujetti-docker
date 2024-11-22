FROM alpine:3.20

RUN apk add --no-cache nginx supervisor nano sqlite openssl php83 php83-fpm php83-mbstring php83-session php83-ctype php83-pdo php83-pdo_sqlite php83-openssl php83-sodium php83-fileinfo php83-zip php83-curl

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY config/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY config/php.ini /etc/php83/conf.d/custom.ini

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/www/html/public/uploads
RUN mkdir -p /var/www/sivujetti-backend

RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /var/www/sivujetti-backend && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

USER nobody

WORKDIR /var/www
COPY --chown=nobody to-htdocs/index.php html/index.php
COPY --chown=nobody to-htdocs/public/ html/public/
COPY --chown=nobody to-outside-htdocs/ sivujetti-backend/

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]