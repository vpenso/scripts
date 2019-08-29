# iNet Wireless Daemon

`iwd` (iNet wireless daemon) aims to replace WPA supplicant

- No external dependencies, base on kernel features
- Can be combined with systemd-networkd

```bash

systemctl enable --now iwd           # start/enable service
iwctl device list                    # list wireless devices
iwctl device <dev> show              # show device details
iwctl station list                   # list state
iwctl station <dev> scan             # scan for networks
iwctl station <dev> get-networks     # list networks
iwctl station <dev> connect <ssid>   # connect to network
```

```bash
# locate the service executable
/var/lib/iwd# systemctl cat iwd.service | grep ExecStart
ExecStart=/usr/libexec/iwd
# print version information
/usr/libexec/iwd --version
# run in foreground with debug mode 
IWD_TLS_DEBUG=1 /usr/libexec/iwd -d
```

## References

[iwdwiki] Wiki Documentation  
https://iwd.wiki.kernel.org/start

[iwdconf] Configuration File Format  
https://iwd.wiki.kernel.org/networkconfigurationsettings
