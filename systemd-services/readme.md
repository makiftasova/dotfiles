## sway-headless.service
* *depends*: sbin/sway-remote-run
* copy into `~/.config/systemd/user` and enable with `systemctl enable --user sway-headless.service`
* expects `sbin/sway-remote-run` script to present in system-wide PATH (e.g. `/usr/local/bin`)
