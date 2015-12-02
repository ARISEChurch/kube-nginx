pkgname=nginx
pkgver=${NGINX_VERSION}
srcdir=/tmp/build/nginx-${NGINX_VERSION}
_nginxrtmpver=1.1.7
_nginxstickyver=1.2.6
_rundir=/var/run/$pkgname
_logdir=/var/log/$pkgname
_homedir=/var/lib/$pkgname
_tmpdir=$_homedir/tmp
_datadir=/usr/share/$pkgname
_confdir=/etc/$pkgname

wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}

# rtmp
wget -O rtmp.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v$_nginxrtmpver.tar.gz
tar -xzf rtmp.tar.gz

# sticky
wget -O sticky.tar.gz https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/$_nginxstickyver.tar.gz
tar -xzf sticky.tar.gz

# Create nginx user
adduser -S nginx
addgroup -S nginx

./configure \
	--prefix=$_datadir \
	--sbin-path=/usr/sbin/$pkgname \
	--conf-path=$_confdir/$pkgname.conf \
	--pid-path=$_rundir/$pkgname.pid \
	--lock-path=$_rundir/$pkgname.lock \
	--error-log-path=$_logdir/error.log \
	--http-log-path=$_logdir/access.log \
	--http-client-body-temp-path=$_tmpdir/client_body \
	--http-proxy-temp-path=$_tmpdir/proxy \
	--http-fastcgi-temp-path=$_tmpdir/fastcgi \
	--http-uwsgi-temp-path=$_tmpdir/uwsgi \
	--http-scgi-temp-path=$_tmpdir/scgi \
	--user=nginx \
	--group=nginx \
	--with-ipv6 \
	--with-file-aio \
	--with-pcre-jit \
	--with-http_dav_module \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_gzip_static_module \
	--with-http_v2_module \
	--with-http_auth_request_module \
	--with-mail \
	--with-mail_ssl_module \
	--add-module="$srcdir/nginx-rtmp-module-1.1.7" \
	--add-module="$srcdir/nginx-goodies-nginx-sticky-module-ng-c78b7dd79d0d"
make
make install
