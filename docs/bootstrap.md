## Bootstrap

...my working environment...

Write a [net-install image](https://www.debian.org/distrib/netinst) from Debian
to a USB device.

Install and de-select all package groups (node Desktop, print server, etc.)

After reboot configure [Sudo](linux/sudo.md) for my user account:

```bash
apt update && apt install -y sudo vim git
echo "$user ALL=(ALL) ALL" > /etc/sudoers.d/$user
```

Login to the user account:

```bash
# clone this repository
mkdir ~/projects
git clone http://github.com/$USER/scripts.git ~/projects/scripts
# install my dependecies
~/project/scripts/bin/apt-default-packages
# make Zsh my default shell
sudo usermod -s /bin/zsh $USER      # relogin
# initialize my user environment
source ~/projects/scripts/source_ms.sh # relogin
# install the i3 window manager, inluding the Polybar status bar
i3-build
i3-config
# install additional fonts
font-install-nerdfonts
# install the menu switcher
rofi-config
```


