## Bootstrap

...my working environment...

Write a [net-install image](https://www.debian.org/distrib/netinst) from Debian
to a USB device.

Install and de-select all package groups (node Desktop, print server, etc.)

After reboot configure [Sudo](linux/sudo.md) for my user account:

```bash
apt update && apt install -y git sudo vim
echo "$user ALL=(ALL) ALL" > /etc/sudoers.d/$user
dnf install -y git vim zsh
```

Login to the user account:

```bash
# clone this repository
mkdir ~/projects
git clone http://github.com/$USER/scripts.git ~/projects/scripts
# install my dependencies
sudo ~/project/scripts/bin/apt-install-default
# make Zsh my default shell
sudo usermod -s /bin/zsh $USER
# initialize my user environment
source ~/projects/scripts/source_ms.sh
tmux-config
vim-config
font-install-nerdfonts
source $SCRIPTS/bin/zsh-config
ln -s $SCRIPTS/source_me.sh ~/.zshrc.d/00-scripts.sh
# re-login
```
## Window Manager

```shell
## sway (re-login)
apt-install-sway
## terminator configuration
diffcp -r $SCRIPTS/etc/terminator/config ~/.config/terminator/config
```

```shell
## i3
i3-build
i3-config
# if polybar is not available as package
polybar-build
# install the menu switcher
rofi-config
```

## Wifi

Add `non-free` to `/etc/apt/sources.list`

```bash
sudo apt install -y firmware-atheros
# or
sudo apt install -y firmware-iwlwifi
# make sure to run
rfkill unblock wlan
```
