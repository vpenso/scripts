# Rofi

Files                     | Description
--------------------------|-------------------------
[bin/rofi-config][1]      | Install Rofi configuration
[etc/rofi/config.rasi][3] | Rofi configuration file
[etc/rofi/white.rasi][2]  | Rofi theme (primarily white colors)

[1]: ../../bin/rofi-config
[2]: white.rasi
[3]: config.rasi

Rofi is started by hot keys in the i3 configuration [etc/i3/config](../i3/config):

```bash
>>> grep rofi $SCRIPTS/etc/i3/config
bindsym $mod+F2 exec --no-startup-id rofi -show run -theme white
bindsym $mod+F3 exec ~/projects/scripts/bin/rofi-bookmarks
bindsym $mod+F4 exec --no-startup-id rofi -show bc -theme white -modi bc:~/.config/rofi/rofi-bc-script
```

### Reference

Rofi: A window switcher, application launcher and dmenu replacement  
https://github.com/davatorium/rofi

Collcetion of Rofi user scripts  
https://github.com/davatorium/rofi/wiki/User-scripts

Rofi Transparency  
https://blog.sarine.nl/2017/04/10/rofi-140-sneak-preview7.html
