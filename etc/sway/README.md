## Sway

Install Sway using package management

```bash
# Debian >=11
sudo apt install -y \
      sway \
      swayidle \
      swaylock \
      upower \
      wdisplays \
      wl-clipboard \
      wofi \
      xwayland
```

Packages used with Wayland, Wlroots, and Sway:

* `imv` image viewer (wayland native)
* `jq` required to `status.sh`
* `upower` power management used in `status.sh`
* `wdisplays` GUI output display manager
* `wl-clipboard` clipboard copy/paste

Configuration in this directory:

Files                        | Description
-----------------------------|---------------------------------------
`config`                     | Sway configuration files includes `config.d/*`
`config.d/*`                 | Specific Sawy configurations for components
`lock.sh`                    | `swaylock` script used in `config.d/keys`
`status.sh`                  | `swaybar` script used in `config.d/swaybar`

Related files in this repository:

Files                        | Description
-----------------------------|---------------------------------------
[`var/aliases/sway.sh`][01]  | Load Sway configuration to the environment

```shell
# load the configuration manually
source $SCRIPTS/var/aliases/sway.sh
# reload the configuration file
swaymsg reload
```

### References

[swscr] Sway Source Code Reository, GitHub  
<https://github.com/swaywm/swayhttps://github.com/swaywm/sway>

[01]: ../../var/aliases/sway.sh
