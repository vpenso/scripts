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

[X Keyboard Extension][xkb] (XKB) handels keyboard settings and layouts in X11

Configuration Files:

```bash
# default keyboard layout 
/etc/default/keyboard
# virtual console keymap configuration
/etc/vconsole.conf
# keymap files (usually corresponds to one keyboard)
find /usr/share/kbd/keymaps/ -type f
# list of keyboard models known to XKB
/usr/share/X11/xkb/rules/base.lst
```

`setxkbmap` **non-permanent changes**:

```bash
# set a keymap just for current session.
loadkeys <keymap>
# get current keyboard layout
setxkbmap -query | grep layout
# set the keyboard layout, i.e. to `de` (german)
setxkbmap de
# toggle keyboard layout with ALT+SHIFT
setxkbmap -layout us,de -option grp:alt_shift_toggle
```

`localectl` is a Systemd tool to...

> query and change the system locale and keyboard layout settings...modify files
> such as `/etc/locale.conf` and `/etc/vconsole.conf`.

```bash
localectl                           # show language configuration
localectl list-locales              # list vailable keys configuration
localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
localectl list-keymaps              # list all available keyboard layouts
localectl set-keymap <keymap>       # persistent configuration
# get messages from the service log
journalctl -u systemd-localed
```

Configure two keyboard layouts, the keyboard model and options:

* `--no-convert` keymap is also converted to the closest matching console keymap.

```bash
localectl --no-convert set-x11-keymap us,de pc104,dvorak grp:alt_shift_toggle
```
[xkb]: https://www.x.org/wiki/XKB/

