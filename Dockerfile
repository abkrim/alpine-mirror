FROM alpine:3.13

LABEL maintainer="Abdelkarim Mateos abdelkarim.mateos@castris.com" \
    description="Docker image for rsync automatic updating of Alpine repository" \
    version="0.0.1"

RUN apk add --update --no-cache \
    nginx rsync openssh bash supervisor tzdata && \
    rm /etc/nginx/conf.d/default.conf && rm -rf /var/cache/apk/*

# Configure nginx
COPY docker-config/nginx.conf /etc/nginx/nginx.conf

# Configure supervisord
COPY docker-config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure rsync repo
COPY docker-config/rsync.sh /etc/periodic/hourly/package-rsync
RUN chmod +x /etc/periodic/hourly/package-rsync
COPY docker-config/rsyncd.conf /etc/rsyncd.conf
COPY docker-config/rsyncd /etc/conf.d/rsyncd
COPY docker-config/exclude.txt /etc/rsync/exclude.txt

# Setup document root
RUN mkdir -p /var/www/repo

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/repo && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Add application
WORKDIR /var/www/repo
COPY --chown=nobody . /var/www/repo/

# Expose the port nginx is reachable on
EXPOSE 80


CMD ["crond", "-f", "-d", "6"]

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
