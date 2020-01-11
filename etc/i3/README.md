# i3

Design principles of i3:

* Minimalism - "Just a" window manager, no integration with applications
* Tiling - Efficient non-overlapping positioning of application windows
* Keyboard Workflow - Complete functionality mapped to (customizable) shortcuts
* Integration - Easy integration with launchers (i.e. Rofi) status bars (i.e. Polybar)
* Optional floating windows support

File                             | Description
---------------------------------|-----------------------
[bin/i3-build][01]               | Build from source, and install i3
[bin/i3-config][08]              | Write i3 configuration to /etc
[bin/i3-cheat][04]               | Show i3 key binding
[bin/i3-exit][05]                | i3 wrapper script for screen lock and power control
[bin/i3-get-window-criteria][07] | Identify application window names/labels in i3
[etc/i3/config][02]              | i3 configuration file
[var/aliases/i3.sh][03]          | Configure i3 environment

## Installation

Install i3 from a minimal installation (no GUI) of Debian

```bash
apt install -y git sudo wget curl
# configure sudo for your user account
# install the window manager, install Polybar cf. etc/polybar/README.md
i3-build
# write i3 & Polybar configuration to /etc
i3-config
```

## Usage

Start i3 after user login on a console:

```bash
i3-start
```

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

[i3twm] i3 Tiling Window Manager  
https://i3wm.org/

[i3usr] i3 User Guide  
https://i3wm.org/docs/userguide.html

[i3gap] i3 Fork with Window Gaps  
https://github.com/Airblader/i3

[sway] i3 compatible implementation on Wayland  
https://swaywm.org

[01]: ../../bin/i3-build
[02]: config
[03]: ../../var/aliases/i3.sh
[04]: ../../bin/i3-cheat
[05]: ../../bin/i3-exit
[06]: ../../docs/linux/wm/i3.md
[07]: ../../bin/i3-get-window-criteria
[08]: ../../bin/i3-config
