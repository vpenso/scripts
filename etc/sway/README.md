

```bash
sudo apt install -y sway xwayland
# use the configuration within this repository
mkdir -p ~/.config/sway
ln -s $SCRIPTS/etc/sway/config ~/.config/sway/config
# reload the configuration file
swaymsg reload
 ```
