
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
