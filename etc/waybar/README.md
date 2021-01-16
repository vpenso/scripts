### Waybar

Status bar for Wayland, Wlroots, and Sway.

```bash
sudo apt install -y waybar       # Debain >=11
```

`$SCRIPTS/etc/sway/config` loads Waybar with following configuration:

```sh
bar {
    swaybar_command waybar
}
```

Waybar expects its configuration in `~/.config/waybar` by default.
`$SCRIPTS/var/aliases/waybar.sh` links this path into this repository.

### References

[wbscr] WayBar Source Code Repository, GitHub  
<https://github.com/Alexays/Waybar>

[wbwcf] Waybar Wiki - Configuration, GitHub  
<https://github.com/Alexays/Waybar/wiki/Configuration>
