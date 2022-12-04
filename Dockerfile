FROM alpine:3.17

RUN apk add --no-cache nginx supervisor nano sqlite openssl php81 php81-fpm php81-mbstring php81-session php81-ctype php81-pdo php81-pdo_sqlite php81-openssl php81-sodium php81-fileinfo

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY config/php.ini /etc/php81/conf.d/custom.ini

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