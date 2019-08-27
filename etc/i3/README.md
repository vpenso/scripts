# i3

File                     | Description
-------------------------|-----------------------
[bin/i3-install][01]     | Build from source, and install i3
[bin/i3-cheat][04]       | Show i3 key binding
[bin/i3-exit][05]        | i3 wrapper script for screen lock and power control
[docs/linux/wm/i3.md][06]| i3 documentation
[etc/i3/config][02]      | i3 configuration file
[var/aliases/i3.sh][03]  | Configure i3 environment

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

[01]: ../../bin/i3-install
[02]: config
[03]: ../../var/aliases/i3.sh
[04]: ../../bin/i3-cheat
[05]: ../../bin/i3-exit
[06]: ../../docs/linux/wm/i3.md
