kubernetes-reverseproxy Docker file
=======================


This repository contains **Dockerfile** that acts as reverse proxy for [Kubernetes](https://github.com/GoogleCloudPlatform/kubernetes) allowing you to route http traffic to kubernetes pods which are sharing the same host port. Requests are proxied based on the hostname.

This is useful in situations where you might want to run numerous websites on the same node ( with same public ip ).

This docker image (Dockerfile) uses [nginx](http://nginx.org/) as reverse proxy and [confd](https://github.com/kelseyhightower/confd) as a way to pull the kubernetes 'service' settings and build nginx configuration.


### Requirements

* This Dockerfile requires the latest kubernetes code which provides support for annotations and ip-per-service capabilities.
* Docker container must have access to the same Etcd cluster on which kubernetes is installed


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/arisechurch/kubernetes-reverseproxy/) from public [Docker Hub Registry](https://registry.hub.docker.com/):

	```docker pull arisechurch/kubernetes-reverseproxy```


### Usage

    docker run -d -e CONFD_ETCD_NODE=<ETCD-IP>:<ETCD-PORT> -t -p 80:80 arisechurch/kubernetes-reverseproxy

**ETCD-IP** = IP/hostname of the etcd server, this is the IP that is accessible from wihtin the container

**ETCD-PORT** = Etcd port, usually : 4001

Example:

	docker run -d -e CONFD_ETCD_NODE=172.17.8.101:4001 -t -p 80:80 arisechurch/kubernetes-reverseproxy

#### Configure kubernetes service

All you need to do is add some extra metadata to your service file for the proxy
to add your endpoints to the nginx configuration.

It will use the first `port` listed in your service configuration.

```yaml
metadata:
  name: myservice
  labels:
    nginx/type: external
  annotations:
    nginx/host: some.host.com
```

`annotations` are used to configure the nginx http directive. Keys include:

**nginx/host** = This is the hostname that nginx will match against to proxy to
your service

**nginx/websocket** =  1 | 0  [default 0] This enables websocket support in nginx, it adds to nginx :
```
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
```

**nginx/sslCrt** = The SSL certificate file for this service (must be located in /etc/nginx/ssl)
**nginx/sslKey** = The SSL private key file for this service (must be located in /etc/nginx/ssl)

The ssl properties add to the nginx config:

```
								ssl_certificate           /etc/nginx/ssl/cert.crt;
								ssl_certificate_key       /etc/nginx/ssl/key.key;

								ssl on;
								ssl_session_cache  builtin:1000  shared:SSL:10m;
								ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
								ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
								ssl_prefer_server_ciphers on;
```
