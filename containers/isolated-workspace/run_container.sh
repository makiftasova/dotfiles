#!/bin/sh

podman run --detach --rm --replace \
	--name isolated-workspace \
	--hostname makiftasova-remote \
	--cap-add=NET_ADMIN \
	--cap-add=NET_RAW \
	--device /dev/net/tun:/dev/net/tun \
	-v /sys/fs/cgroup:/sys/fs/cgroup:rw \
	-v tailscale-state:/var/lib/tailscale \
	isolated-workspace /lib/systemd/systemd
