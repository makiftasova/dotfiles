# ISOLATED WORKSPACE CONTAINER

This container exists to provide an isolated workspace for tasks you don't want
to let loose on your system.

## Usage

* Use `build_container.sh` to build container using `podman`
* Use `run_container.sh` to use/run container after building.
* You can use `config/containers/systemd/isolated-workspace.container` to run
  this container as a systemd server after building it.

## Features

* By default, a directory at `/tmp/isolated-workspace` on host is created and
  mounted to `/exchange` in container to provide bidirectional file transfer
  capability between host and container.
* GUI apps work out of the box on a Wayland host: Wayland apps via the
  mounted wayland-1 socket, X11 apps via the mounted X socket (XWayland).
  X11 apps must be run as user `makiftasova`, not root (see the
  `isolated-workspace` shell alias).
