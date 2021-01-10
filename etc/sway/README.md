
Packages:

* `imv` image viewer
* `upower` power management used in `status.sh`

```bash
sudo apt install -y \
      imv \
      sway \
      upower \
      xwayland
# use the configuration within this repository
source $SCRPITS/var/aliases/sway.sh
# reload the configuration file
swaymsg reload
 ```
