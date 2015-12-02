FROM smebberson/alpine-base:1.2.0

ENV NGINX_VERSION 1.9.7
ENV APK_PACKAGES "openssl-dev pcre-dev zlib-dev wget build-base ca-certificates linux-headers"

ADD https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 /usr/local/bin/confd
ADD root /

RUN apk add --update $APK_PACKAGES && \
    # build nginx
    cd /tmp/build && \
    sh build.sh && \
    chmod +x /etc/services.d/nginx/run && \
    chmod +x /etc/services.d/confd/run && \
    mkdir -p /var/lib/nginx/tmp/client_body && \
    chown nginx:www-data -R /var/lib/nginx && \
    # setup confd
    chmod u+x /usr/local/bin/confd && \
    # send logs to stdout and stderr
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # cleanup
    apk del $APK_PACKAGES && \
    apk add --update pcre openssl && \
    rm -rf /tmp/build /var/cache/apk/*

EXPOSE 80 443
