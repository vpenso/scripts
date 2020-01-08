### Polybar

[Polybar][0] (cf. github:[polybar][1])

> Polybar aims to help users build beautiful and highly customizable status 
> bars for their desktop environment.

Files                      | Description
---------------------------|---------------------------
[etc/polybar/config][3]    | Configuration within this repository
[etc/polybar/launch.sh][4] | Launch script used with i3 window manager
[bin/polybar-build][5]     | Build from source, and install
[var/aliases/polybar.sh][6]| Setup the environment

Test the configuration:

```bash
polybar --config=$SCRIPTS/etc/polybar/config top
```

Launch Polybar with i3 (cf. `~/.i3/config`):

```bash
exec_always --no-startup-id ~/.config/polybar/launch.sh
```

Read the documentation in the [Polybar Wiki][2].

## Build

Get the latest release version:

<https://github.com/polybar/polybar/releases>

Run [`polybar-build`][5] to download, build and install Polybar.

i3 should be installed before building comtpon to enable support:

```bash
# check if i3 support is available
>>> polybar -vvv | grep Feature
Features: +alsa +curl +i3 +mpd +network(libnl) +pulseaudio +xkeyboard
```

[0]: https://polybar.github.io/
[1]: https://github.com/jaagr/polybar
[2]: https://github.com/jaagr/polybar/wiki
[3]: config
[4]: launch.sh
[5]: ../../bin/polybar-build
[6]: ../../var/aliases/polybar.sh
