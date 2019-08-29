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

## References

[iwdwiki] Wiki Documentation  
https://iwd.wiki.kernel.org/start

[iwdconf] Configuration File Format  
https://iwd.wiki.kernel.org/networkconfigurationsettings
