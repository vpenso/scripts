
```bash
# simple graphical configuration
arandr
# list output devices
xrandr --listactivemonitors
xrandr --output HDMI1 --right-of eDP1 --auto
```

Mirror two screens:

```bash
xrandr --output HDMI-1 --same-as eDP-1
```
