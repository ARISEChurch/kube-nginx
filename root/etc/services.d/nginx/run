#!/usr/bin/with-contenv sh

export ETCD=$CONFD_ETCD_NODE

echo "[nginx] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/myconfig.toml; do
  echo "[nginx] waiting for confd to refresh nginx.conf"
  sleep 5
done

# Start nginx
echo "[nginx] starting nginx service..."
exec nginx -g "daemon off;";
