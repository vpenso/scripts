# Sway

## Installation

Install Sway using package management

```bash
# Debian >=11
sudo apt install -y \
      gammastep \
      grimshot \
      light \
      mpv \
      slurp \
      sway \
      swayidle \
      swaylock \
      upower \
      wdisplays \
      wf-recorder \
      wl-clipboard \
      wofi \
      xwayland
```

Packages used with Wayland, Wlroots, and Sway:

* `gammastep` brightness configuration
* `grimshot` screen capture utility
* `light` LCD brightness control
* `mpv` video playback
* `slurp` selects a region in Wayland
* `upower` power management used in `status.sh`
* `wdisplays` GUI output display manager
* `wl-clipboard` clipboard copy/paste

## Configuration


Files                        | Description
-----------------------------|---------------------------------------
`config`                     | Sway configuration files includes `config.d/*`
`config.d/*`                 | Specific Sway configurations for components
`config.d/float`             | Move windows into the float area, apps. floating by default
`lock.sh`                    | `swaylock` script used in `config.d/keys`
[`var/aliases/sway.sh`][01]  | Load Sway configuration to the environment
[`var/cheat/sway.md`][04]    | Keyboard binding cheat sheet

```shell
# load the configuration manually
source $SCRIPTS/var/aliases/sway.sh
# reload the configuration file
swaymsg reload
```

### Status Line

Sway default status line `swaybar`

Files                        | Description
-----------------------------|---------------------------------------
`status.sh`                  | Status line script used by `swaybar`
`config.d/swaybar`           | Enable `swaybar` configuration

More customizable status line with `waybar` (replacing `swaybar`) 

Files                        | Description
-----------------------------|---------------------------------------
[`etc/waybar`][02]           | Configuration files
`config.d/waybar`            | Enable WayBar in Sway

### Applications

Screenshots with `grim`, `slurp` and `grimshot` [grim]:

Files                        | Description
-----------------------------|---------------------------------------
`config.d/grimshot`          | Key binding for `grimshot`

Volume and microphone control with `pulseaudio`:

Files                        | Description
-----------------------------|---------------------------------------
`config.d/pulseaudio`        | Key binding to function keys

Screen recording with `wf-recorder`:

Files                        | Description
-----------------------------|---------------------------------------
`toggle-wf-recorder.sh`      | Help script to control `wf-recorder`
`config.d/wf-recorder`       | Key binding to enable/disable `wf-recorder`


Application launcher `wofi`:

Files                        | Description
-----------------------------|---------------------------------------
[`etc/wofi`][03]             | `wofi` configuration files
`config.d/wofi`              | Key binding for `wofi`

### References

[swscr] Sway Source Code Reository, GitHub  
<https://github.com/swaywm/sway>

[grims] Grim & Slurp Wayland tools for Screen Shots  
<https://wayland.emersion.fr/grim/>  
<https://wayland.emersion.fr/slurp/>  
<https://github.com/swaywm/sway/blob/master/contrib/grimshot>

[01]: ../../var/aliases/sway.sh
[02]: ../waybar/
[03]: ../wofi/
[04]: ../../var/cheat/sway.md
