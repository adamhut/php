FROM php:7.3-fpm-stretch

# Install Caddy
# @todo download caddy
RUN curl --silent --show-error --fail --location \
    --header "Accept: application/tar+gzip, application/x-gizp, application/octet-stream" -o - \
    "https://caddyserver.com/download/linux/amd64?plugins=http.expires,http.realip&license=personal&telemetry=on" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && caddy -version \
    && docker-php-ext-install mbstring pdo pdo_mysql \
    && mkdir -p /srv/app/pubilc

COPY . /srv/app
COPY Caddyfile /etc/Caddyfile

WORKDIR /srv/app

RUN chown -R www-data:www-data /srv/app

EXPOSE 80

CMD ["/usr/bin/caddy","--conf","/etc/Caddyfile" ,"--log" ,"stdout"]
# CMD ["/usr/local/bin/caddy"]

