# systemd-networkd

Systemd service that manages network configurations:

* Detects and configures network devices as they appear

```bash
ls -l {/etc,/run,/lib}/systemd/network/*.network # network configuration 
networkctl list                                  # list network connections
networkctl status                                # show IP addresses for interfaces
```

## Configuration

### Predictable interface names

Prefix `en` Ethernet `wl` WLAN with following types:

```
o<index>                                                         on-board device index number
s<slot>[f<function>][d<dev_id>]                                  hotplug slot index number
x<MAC>                                                           MAC address
p<bus>s<slot>[f<function>][d<dev_id>]                            PCI geographical location
p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>] USB port number chain
```

Cf. `/lib/udev/rules.d/80-net-setup-link.rules`, cf. `systemd.link`

```bash
udevadm info -e | grep -A 9 ^P.*en[sop]          # dump udev database and grep for ethernet
udevadm test /sys/class/net/* 2>&- | grep ID_NET_NAME_
## -- .link file are used to rename an interface -- ##
ls -l {/etc,/run,/lib}/systemd/network/*.link    # list link configuration files
ip -o -4 link                                    # show link state
```

### Unit File

Configure the network, cf. `systemd.network`

Skeleton for a **dynamic IP-address**

```
[Match]
Name=                              # device name (e.g en*)

[Network]
DHCP={yes,no,ipv4,ipv6}            # enable DHCP
```

Skeleton for a **static IP-address**

```
[Match]
Name=              # device name (e.g en*)

[Network]
Address=           # IP address, CIDR notation
Gateway=           # IP address
DNS=               # is a DNS server address (multiples possibel)
Domains=           # a list of the domains used for DNS host name resolution
```

**Wired and wireless adapters on the same machine**

```bash
cat <<EOF | sudo tee /etc/systemd/network/20-wired.network
Name=en*

[Network]
DHCP=ipv4

[DHCP]
RouteMetric=10
EOF 
cat <<EOF | sudo tee /etc/systemd/network/25-wireless.network
Name=wl*

[Network]
DHCP=ipv4

[DHCP]
RouteMetric=20
EOF
```

Note that the wireless interface needs to be connected by another service 
like `iwd`.

`systemd-resolved` service is required if DNS entries are specified in `.network` files

## Service

Persistently enable the service:

```bash
# eventually prevent NetworkManager [1] from controlling the network interface:
systemctl disable --now NetworkManager
systemctl mask NetworkManager
# enable systemd-networkd
systemctl enable --now systemd-networkd
```

Debugging:

```bash
SYSTEMD_LOG_LEVEL=debug /lib/systemd/systemd-networkd   # execute with debugging in foreground
# Permanent by drop-in configuration
mkdir /etc/systemd/system/systemd-networkd.service.d/
echo -e "[Service]\nEnvironment=SYSTEMD_LOG_LEVEL=debug" > /etc/systemd/system/systemd-networkd.service.d/10-debug.conf 
systemctl daemon-reload && systemctl restart systemd-networkd
```


## Reference

[1] Gnome NetworkManager Reference Manual  
<https://developer.gnome.org/NetworkManager/>

