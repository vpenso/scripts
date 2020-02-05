# Localization

Set environment variables necessary for native language support:

```bash
apt install console-data
/etc/locale.conf                    # system-wide locale settings
locale -a                           # list of all locales supported
```

* Output of programs translated into the native language
* Classification of characters into letters, digits and other classes
* Correct alphabetical sorting order for the country
* Appropriate default paper size
* Correct formatting of monetary, time, and date values


Configuration Files:

```bash
# default keyboard layout 
/etc/default/keyboard
# virtual console keymap configuration
/etc/vconsole.conf
# keymap files (usually corresponds to one keyboard)
find /usr/share/kbd/keymaps/ -type f
# interactively enter a key and see what keysym it is configure
xev | grep keysym
```

`loadkeys` loads or modifies the keyboard driver's translation tables

```
# set german keyboard for current console
loadkeys de
```

## X11

X Keyboard Extension (XKB) handles keyboard settings and layouts in X11

```bash
# list of keyboard models known to XKB
/usr/share/X11/xkb/rules/base.lst
# list available toggle keys
grep "grp:.*toggle" /usr/share/X11/xkb/rules/base.lst
```

`setxkbmap` for **non-permanent** changes:

```bash
# get current keyboard layout
setxkbmap -query | grep layout
# set the keyboard layout, i.e. to `de` (german)
setxkbmap de
# toggle keyboard layout with ALT+SHIFT
setxkbmap -layout us,de -option grp:alt_shift_toggle
```

Add a **permanent** keyboard configuration: 

```bash
sudo mkdir -p /etc/X11/xorg.conf.d
cat << EOF | sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
    Identifier "keyboard-all"
    Driver "evdev"
    Option "XkbLayout" "us,de"
    Option "XkbModel" "pc104"
    Option "XkbOptions" "grp:alt_shift_toggle"
    MatchIsKeyboard "on"
EndSection
EOF
```

## Systemd 

`localectl` queries and changes the system locale and keyboard layout
settings...modify files such as `/etc/locale.conf` and `/etc/vconsole.conf`.

```bash
localectl                           # show language configuration
localectl list-locales              # list vailable keys configuration
localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
localectl list-keymaps              # list all available keyboard layouts
localectl set-keymap us,de          # persistent configuration
# get messages from the service log
journalctl -u systemd-localed
```

Instead of manually editing X configuration files:

```bash
localectl --no-convert set-x11-keymap us,de pc104,dvorak grp:alt_shift_toggle
# writes /etc/X11/xorg.conf.d/00-keyboard.conf
```

# References

[xkb] The XKB Configuration Guide  
https://www.x.org/releases/current/doc/xorg-docs/input/XKB-Config.html

