## ISOLATED WORKSPACE CONTAINER

This container exists to provide an isolated workspace for tasks you don't want
to let loose on your system.

### Usage

* Use `build_container.sh` to build contaienr using `podman`
* Use `run_container.sh` to use/run container after building.
* You can use `config/containers/systemd/isolated-workspace.container` to run
this contaier as a systemd server after building it.
