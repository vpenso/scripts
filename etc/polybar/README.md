### Polybar

[Polybar][0] (cf. github:[polybar][1])

> Polybar aims to help users build beautiful and highly customizable status 
> bars for their desktop environment.

Files                      | Description
---------------------------|---------------------------
[etc/polybar/config][3]    | Configuration within this repository
[etc/polybar/launch.sh][4] | Launch script used with i3 window manager

Test the configuration:

```bash
polybar --config=$SCRIPTS/etc/polybar/config top
```

Launch Polybar with i3 (cf. `~/.i3/config`):

```bash
exec_always --no-startup-id ~/.config/polybar/launch.sh
```

Read the documentation in the [Polybar Wiki][2].

[0]: https://polybar.github.io/
[1]: https://github.com/jaagr/polybar
[2]: https://github.com/jaagr/polybar/wiki
[3]: config
[4]: launch.sh
