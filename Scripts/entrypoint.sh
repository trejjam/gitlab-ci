#!/bin/bash

set -e

chown www-data:www-data -R /home/www-data

if [[ -n $SHARE_APPLICATION_NFS ]]; then
	PID=0

	function shutdown {
		echo "- Shutting down nfs-server.."
		service nfs-kernel-server stop
		/usr/sbin/exportfs -uav
		echo "- Nfs server is down"

		kill $PID

		exit 0
	}

	trap 'shutdown' SIGKILL SIGTERM SIGHUP SIGINT EXIT

	echo "/var/www *(ro,sync,insecure,fsid=0,no_subtree_check,no_root_squash)" | tee /etc/exports

	rpcbind -w

	service nfs-kernel-server start

	bash -c "$@" &
	PID=$!

	wait $PID

	exit 0
fi

exec "$@"
