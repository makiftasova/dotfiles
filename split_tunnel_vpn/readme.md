# Needed Files
1. place `wg_netns_start` and `wg_netns_run` scripts into `/usr/local/bin` or user's path.
2. replace `yourusername` with your actual username in file `netns_vpn`, and copy it to `/etc/sudoers.d`
3. copy accompanying `wg-vpn-run@.service` file to `${HOME}/.config/systemd/user`
4. run command `systemctl --user daemon-reload`
5. put your wireguard config file to `/etc/wireguard`
6. run command `systemctl --user start wg_netns_start@${config_name}` to start vpn namespace
    - e.g. if your config file is `/etc/wireguard/wg0.conf`, run command as `systemctl --user start wg_netns_start@wg0`
7. run command `systemctl --user start wg_netns_run@${command}` to run your applicaiton inside vpn namespace
    - e.g. if you want to run `firefox` in vpn namespace, run `systemctl --user start wg_netns_run@firefox`

# NOTES
* if you want to pass arguments to command, you can use `systemd-escape`:
```bash
UNIT_NAME=$(systemd-escape "chromium --incognito")
systemctl --user start "wg_netns_run@${UNIT_NAME}.service"
```
