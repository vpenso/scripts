### Waybar

Status bar for Wayland, Wlroots, and Sway.

```bash
sudo apt install -y waybar       # Debain >=11
~/.config/waybar                 # default configuration path
```

File                                | Description
------------------------------------|-----------------------------------------
[etc/sway/config.d/waybar][01]      | Load this configuration in Sway
[var/aliases/waybar.sh][02]         | Configure the local environment
`config.d/`                         | Configuration files
`config`                            | Active configuration
`styles.d/`                         | Style (CSS) configuration files
`style.css`                         | Active style

[01]: ../sway/config.d/waybar
[02]: ../../var/aliases/waybar.sh

### References

[wbscr] WayBar Source Code Repository, GitHub  
<https://github.com/Alexays/Waybar>

[wbwcf] Waybar Wiki - Configuration, GitHub  
<https://github.com/Alexays/Waybar/wiki/Configuration>
