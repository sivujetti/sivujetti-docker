FROM alpine:3.18

RUN apk add --no-cache nginx supervisor nano sqlite openssl php82 php82-fpm php82-mbstring php82-session php82-ctype php82-pdo php82-pdo_sqlite php82-openssl php82-sodium php82-fileinfo php82-zip php82-curl

RUN ln -s /usr/bin/php82 /usr/bin/php

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY config/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY config/php.ini /etc/php82/conf.d/custom.ini

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