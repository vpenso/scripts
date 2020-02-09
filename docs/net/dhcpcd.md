
dhcpcd daemon, and optionally WPA supplicant

```bash
# run debug mode, foreground
dhcpcd -Bd -f /etc/dhcpcd.conf
```

## Configuration

```bash
/etc/dhcpcd.conf
```

Prevent the configuration of an interface:

> When discovering interfaces, the interface name must not match pattern which
> is a space or comma separated list of patterns passed to fnmatch(3).

```bash
denyinterfaces wlan0        # do not configure WiFi
```


