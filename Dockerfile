#
# Reverse proxy for kubernetes
#
FROM smebberson/alpine-nginx:latest

ADD https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 /usr/local/bin/confd

####

ADD ./src/nginx.sh /etc/services.d/nginx/run
ADD ./src/confd.sh /etc/services.d/confd/run
RUN chmod +x /etc/services.d/nginx/run && \
    chmod +x /etc/services.d/confd/run && \
    # setup confd
    chmod u+x /usr/local/bin/confd && \
    mkdir -p /etc/confd/conf.d && \
    mkdir -p /etc/confd/templates && \
    # send logs to stdout and stderr
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

ADD ./src/confd/conf.d/myconfig.toml /etc/confd/conf.d/myconfig.toml
ADD ./src/confd/templates/nginx.tmpl /etc/confd/templates/nginx.tmpl
ADD ./src/confd/confd.toml /etc/confd/confd.toml
