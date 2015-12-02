#!/usr/bin/with-contenv sh

export ETCD=$CONFD_ETCD_NODE

echo "[confd] booting container. ETCD: $ETCD"

# Run confd in the background to watch the upstream servers
echo "[confd] listening for changes on etcd..."
exec confd -interval 10 -node $ETCD -config-file /etc/confd/conf.d/myconfig.toml
