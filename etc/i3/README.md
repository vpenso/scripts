# i3

Design principles of i3:

* Minimalism - "Just a" window manager, no integration with applications
* Tiling - Efficient non-overlapping positioning of application windows
* Keyboard Workflow - Complete functionality mapped to (customizable) shortcuts
* Integration - Easy integration with launchers (i.e. Rofi) status bars (i.e. Polybar)

File                             | Description
---------------------------------|-----------------------
[bin/i3-install][01]             | Build from source, and install i3
[bin/i3-cheat][04]               | Show i3 key binding
[bin/i3-exit][05]                | i3 wrapper script for screen lock and power control
[bin/i3-get-window-criteria][07] | Identify application window names/labels in i3
[etc/i3/config][02]              | i3 configuration file
[var/aliases/i3.sh][03]          | Configure i3 environment

### Installation

Install i3 from a minimal installation (no GUI)  of Debian

```bash
apt install -y git sudo wget curl
# configure sudo for your user account
# install the window manager
i3-install
# install the status bar cf. etc/polybar
polybar-install
# launch i3
i3-start
```

Global configuration (for all user accounts):

```bash
# backup original configuration
sudo mv /etc/i3/config /etc/i3/config.orig
# deploy configuration from this repository
sudo cp $SCRIPTS/etc/i3/config /etc/i3
sudo mkdir /etc/polybar
sudo cp $SCRIPTS/etc/polybar/{config,launch.sh} /etc/polybar
# adjsut the path to the Polybar executable
>>> diff /etc/i3/config $SCRIPTS/etc/i3/config
17c17
< exec_always --no-startup-id /etc/polybar/launch.sh
---
> exec_always --no-startup-id ~/.config/polybar/launch.sh
# add small hepler function to start i3
echo 'i3-start() { startx /usr/bin/i3 -c /etc/i3/config }' \
        | sudo tee -a /etc/zsh/zshrc
```

### GTK & Qt Configuration

Select a decoration theme:

```bash
apt install -y lxappearance gtk-chtheme qt4-qtconfig
# choose a theme in...
lxappearance
gtk-chtheme
# install favorit theme (note that Arc has a Firefox theme as well)
apt install arc-theme moka-icon-theme
```

## References

[i3wm] i3 Tiling Window Manager  
https://i3wm.org/

[i3usr] i3 User Guide  
https://i3wm.org/docs/userguide.html

[i3gaps] i3 Fork with Window Gaps  
https://github.com/Airblader/i3

[sway] i3 compatible implementation on Wayland  
https://swaywm.org

[01]: ../../bin/i3-install
[02]: config
[03]: ../../var/aliases/i3.sh
[04]: ../../bin/i3-cheat
[05]: ../../bin/i3-exit
[06]: ../../docs/linux/wm/i3.md
[07]: ../../bin/i3-get-window-criteria
