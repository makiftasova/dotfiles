## mosquitto.service
* copy into `~/.config/systemd/user` and enable with `systemctl enable --user mosquitto.service`
* make sure you put a valid mosquitto configuration file to `${HOME}/.config/mosquitto/mosquitto.conf` path.

## python-http-server.service
* *depends*: python
* copy into `~/.config/systemd/user` and enable with `systemctl enable --user python-http-server.service`
* expects `${HOME}/.local/config/serivces/python-http-server.env` file to be present
* can be configured using `${HOME}/.local/config/serivces/python-http-server.env` file

## sway-headless.service
* *depends*: sbin/sway-remote-run
* copy into `~/.config/systemd/user` and enable with `systemctl enable --user sway-headless.service`
* expects `sbin/sway-remote-run` script to present in system-wide PATH (e.g. `/usr/local/bin`)

## tmux.service
* *depends*: /usr/bin/tmux
* copy into `~/.config/systemd/user` and enable with `systemctl enable --user tmux.service`
* expects tmux configuration (`tmux.conf`) file in `${XDG_CONFIG_HOME}/tmux/tmux.conf` path

## tmux@.service
* *depends*: /usr/bin/tmux
* system-wide systemd unit file for running detached tmux sessions
* enable with `systemctl enable tmux@${USER}.service`
* start with `systemctl start tmux@${USER}.service`
* unlike `tmux.service` this unit file is not depends on user session
* copy into `/etc/systemd/system` and enable with `systemctl enable tmux@${USER}.service`
* expects tmux configuration (`tmux.conf`) file in `${XDG_CONFIG_HOME}/tmux/tmux.conf` path

## wayvnc-user.service
* *depends*: /usr/bin/wayvnc
* copy into `~/.config/systemd/user` and enable with `systemctl enable --user wayvnc-user.service`
* expects wayvnc configuration file in `${HOME}/.local/config/wayvnc/config` path
