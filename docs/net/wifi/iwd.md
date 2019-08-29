# iNet Wireless Daemon

`iwd` (iNet wireless daemon) aims to replace WPA supplicant

- No external dependencies, base on kernel features (D-Bus, cryptographic interface)
- Designed to deal with multiple clients from the outset
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
systemctl cat iwd.service | grep ExecStart
ExecStart=/usr/libexec/iwd
# print version information
/usr/libexec/iwd --version
# run in foreground with debug mode 
IWD_TLS_DEBUG=1 /usr/libexec/iwd -d
# Disable periodic scanning of all networks
echo -e '[Scan]\ndisable_periodic_scan=true' >> /etc/iwd/main.conf
```

## Configuration

```bash
/var/lib/iwd                         # network configuration files
```

### WPA2/PSK

The PreSharedKey can be calculated with `wpa_passphrase` (from wpa_supplicant)
from the SSID and the WIFI passphrase:

```bash
>>> wpa_passphrase <ssid>
# reading passphrase from stdin
************
network={
    ssid="<ssid>"
    #psk="***********"
    psk=9d1c20628cabdb224a1a420723478f585f4579efd4b206301b8c0d6e5ddc8296
}

```
```bash
cat > /var/lib/iwd/<ssid>.psk <<EOF
[Security]
PreSharedKey=9d1c20628cabdb224a1a420723478f585f4579efd4b206301b8c0d6e5ddc8296
EOF
```





## References

[iwdwiki] Wiki Documentation  
https://iwd.wiki.kernel.org/start

[iwdconf] Configuration File Format  
https://iwd.wiki.kernel.org/networkconfigurationsettings

[iwdsrc] Source Code Repository
https://git.kernel.org/pub/scm/network/wireless/iwd.git/
