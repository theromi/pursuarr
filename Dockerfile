FROM alpine:3.24

RUN set -eux; \
    apk add --no-cache php85 php85-curl php85-mbstring php85-ctype \
    || { sed -i 's|dl-cdn.alpinelinux.org|mirrors.edge.kernel.org|' /etc/apk/repositories; \
         apk add --no-cache php85 php85-curl php85-mbstring php85-ctype; }

RUN set -eux; \
    addgroup -S pursuarr; \
    adduser -S -G pursuarr -h /app pursuarr; \
    mkdir -p /app /data; \
    chown pursuarr:pursuarr /app /data

WORKDIR /app
COPY --chown=pursuarr:pursuarr index.php /app/index.php

USER pursuarr

ENV PURSUARR_SETTINGS=/data/settings.php \
    PHP_CLI_SERVER_WORKERS=4

VOLUME ["/data"]
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
    CMD ["php", "-r", "exit(@file_get_contents('http://127.0.0.1:8080/') === false ? 1 : 0);"]

CMD ["php", "-d", "display_errors=0", "-d", "log_errors=1", "-S", "0.0.0.0:8080", "-t", "/app"]
