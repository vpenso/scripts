

# Localization

Settings system locale:

```bash
/etc/locale.conf                    # system-wide locale settings
localectl                           # show language configuration
localectl list-locales              # list vailable keys configuration
localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
```

## Keyboard

Keyboard **layout** (arrangement of keys on the keyboard):

* Each language has its own layout.
* QUERTY is the most widespread layout not confined to a particular geographical
  area. Name comes from reading the first six keys appearing on the top left 
  letter row of the keyboard.
* QWERTZ is the normal keyboard layout in Germany, Austria and Switzerland.
* Layout variants represents the changes made to a “macro-layout” to adjust it 
  to a different language.

Keyboard mappings - **keymaps**- (key code referenced by a key press)

* Typically the language code is the same as its country code, e.g. `de` (German)
* **Modifier** keys used to perform alterations on regular characters

[X Keyboard Extension][xkb] (XKB) handels keyboard settings and layouts in X11

Configuration Files:

```bash
# configures teh default keyboard layout 
/etc/default/keyboard
# virtual console keymap configuration
/etc/vconsole.conf
# X11 XKB configuration written by localectl
/etc/X11/xorg.conf.d/00-keyboard.conf
```

Reference files:

```bash
# keymap files (usually corresponds to one keyboard)
/usr/share/kbd/keymaps
# list of keyboard models known to XKB
/usr/share/X11/xkb/rules/base.lst
```

Configure two keyboard layouts, the keyboard model and options:

* `--no-convert` keymap is also converted to the closest matching console keymap.
* Option `grp:alt_shift_toggle` enabls switching the layout with **Alt+Shift**

```bash
localectl --no-convert set-x11-keymap us,de pc104 ,dvorak grp:alt_shift_toggle
```
```bash
# list all available keyboard layouts
localectl list-keymaps              
find /usr/share/kbd/keymaps/ -type f
# persistent configuration
localectl set-keymap <keymap>
# set a keymap just for current session.
loadkeys <keymap>
# get current keyboard layout
setxkbmap -query | grep layout
```

[xkb]: https://www.x.org/wiki/XKB/

