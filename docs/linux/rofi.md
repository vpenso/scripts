
Files                     | Description
--------------------------|-------------------------
[var/aliases/rofi.sh][1]  | Add Rofi configuration to the environment
[etc/rofi][2]             | Rofi configuration files (linked to `~/.config/rofi`)

[1]: ../../../var/aliases/rofi.sh
[2]: ../../../etc/rofi

## User Scripts

Pipe a list of options into `rofi`, the selection is print to stdout:

```bash
echo 'a\nb\nc' | rofi -dmenu -p
```

## Reference

Rofi: A window switcher, application launcher and dmenu replacement  
https://github.com/davatorium/rofi

Collcetion of Rofi user scripts  
https://github.com/davatorium/rofi/wiki/User-scripts
