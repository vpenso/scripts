
Packages:

* `imv` image viewer (wayland native)
* `jq` required to `status.sh`
* `upower` power management used in `status.sh`
* `wdisplays` GUI output display manager
* `wl-clipboard` clipboard copy/paste

```bash
sudo apt install -y \
      imv \
      jq \
      sway \
      swayidle \
      swaylock \
      upower \
      wdisplays \
      wl-clipboard \
      wofi \
      xwayland
# use the configuration within this repository
source $SCRPITS/var/aliases/sway.sh
# reload the configuration file
swaymsg reload
```

Files                        | Description
-----------------------------|---------------------------------------
[`var/aliases/sway.sh`][01]  | Load Sway configuration to the environment
`config`                     | Sway configuration files includes `config.d/*`
`config.d/*`                 | Specific Sawy configurations for components
`lock.sh`                    | `swaylock` script used in `config.d/keys`
`status.sh`                  | `swaybar` script used in `config.d/swaybar`

[01]: ../../var/aliases/sway.sh
