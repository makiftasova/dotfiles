#!/bin/sh

set -eu

exchange_dir="${EXCHANGE_DIR:-/tmp/isolated-workspace}"

# The container user has a subordinate host UID under rootless Podman, so the
# exchange directory must be writable from both the host and container.
install -d -m 0777 "$exchange_dir"

podman run --detach --rm --replace \
	--name isolated-workspace \
	--hostname makiftasova-remote \
	--cap-add=NET_ADMIN \
	--cap-add=NET_RAW \
	--device /dev/net/tun:/dev/net/tun \
	-v /sys/fs/cgroup:/sys/fs/cgroup:rw \
	-v isolated-workspace-home:/home/makiftasova \
	-v isolated-workspace-tailscale:/var/lib/tailscale \
	--mount "type=bind,source=${exchange_dir},target=/exchange" \
	isolated-workspace /lib/systemd/systemd
