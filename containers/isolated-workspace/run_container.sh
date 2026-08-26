#!/bin/sh

set -eu

display="${DISPLAY:-:0}"
gdk_backend="${GDK_BACKEND:-wayland}"
qt_qpa_platform="${QT_QPA_PLATFORM:-wayland}"
wayland_display="${WAYLAND_DISPLAY:-wayland-1}"
xdg_runtime_dir="${XDG_RUNTIME_DIR:-/run/user/1000}"

wayland_socket="${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}"
xwayland_socket='/tmp/.X11-unix/X0'
exchange_dir="${EXCHANGE_DIR:-/tmp/isolated-workspace}"

echo "DISPLAY: ${display}"
echo "GDK_BACKEND: ${gdk_backend}"
echo "QT_QPA_PLATFORM: ${qt_qpa_platform}"
echo "WAYLAND_DISPLAY: ${wayland_display}"
echo "XDG_RUNTIME_DIR: ${xdg_runtime_dir}"

echo "Wayland socket: ${wayland_socket}"
echo "Xwayland socket: ${xwayland_socket}"
echo "Exhange directory: ${exchange_dir}"

# The container user has a subordinate host UID under rootless Podman, so the
# exchange directory must be writable from both the host and container.
install -d -m 0777 "${exchange_dir}"

podman run --detach --rm --replace \
	--name isolated-workspace \
	--hostname makiftasova-remote \
	--userns=keep-id:uid=1000,gid=1000 \
	--cap-add=NET_ADMIN \
	--cap-add=NET_RAW \
	--device /dev/net/tun:/dev/net/tun \
	--env container=podman \
	--env DISPLAY="${display}" \
	--env GDK_BACKEND="${gdk_backend}" \
	--env QT_QPA_PLATFORM="${qt_qpa_platform}" \
	--env WAYLAND_DISPLAY="${wayland_display}" \
	--env XDG_RUNTIME_DIR="${xdg_runtime_dir}" \
	--volume "${wayland_socket}:${wayland_socket}:ro" \
	--volume "${xwayland_socket}:${xwayland_socket}:ro" \
	--volume /sys/fs/cgroup:/sys/fs/cgroup:rw \
	--volume isolated-workspace-home:/home/makiftasova:rw \
	--volume isolated-workspace-tailscale:/var/lib/tailscale:rw \
	--mount "type=bind,source=${exchange_dir},target=/exchange" \
	isolated-workspace /lib/systemd/systemd
