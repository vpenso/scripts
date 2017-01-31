

Using `dnsmasq` as **DHCP server**:

* Disable the service started by default during package deployment
* Very simple DHCP only configuration in `/etc/dnsmasq.conf`
* Start the server in foreground for debugging

```bash
>>> apt install dnsmasq # install the DHCP service package
>>> systemctl stop dnsmasq && systemctl disable dnsmasq
>>> cat /etc/dnsmasq.conf
port=0               # diable DNS service
log-dhcp             # extra verbose on DHCP requests
domain=devops.test   # allow FQDNs
no-hosts             # do not read /etc/hosts
## address pool configuration
dhcp-range=10.1.1.1,10.1.1.254,255.255.255.0,12h
dhcp-host=02:FF:0A:0A:06:05,lxdns01,10.1.1.5
dhcp-host=02:FF:0A:0A:06:06,lxdns02,10.1.1.6
dhcp-host=02:FF:0A:0A:06:1B,lxdev01,10.1.1.27
dhcp-host=02:FF:0A:0A:06:1C,lxdev02,10.1.1.28
dhcp-host=02:FF:0A:0A:06:1D,lxdev03,10.1.1.29
dhcp-host=02:FF:0A:0A:06:1E,lxdev04,10.1.1.30
## additonal options
dhcp-option=option:router,10.1.1.1 # default gateway
>>> dnsmasq --test # syntax check the configuration
dnsmasq: syntax check OK.
>>> dnsmasq --keep-in-foreground --no-daemon
dnsmasq: started, version 2.76 DNS disabled
dnsmasq: compile time options: IPv6 GNU-getopt DBus i18n IDN DHCP DHCPv6 no-Lua TFTP conntrack ipset auth DNSSEC loop-detect inotify
dnsmasq-dhcp: DHCP, IP range 10.1.1.1 -- 10.1.1.254, lease time 12h
dnsmasq-dhcp: ... DHCPDISCOVER(ens3) 02:ff:0a:0a:06:1b
..
dnsmasq-dhcp: ... DHCPOFFER(ens3) 10.1.1.27 02:ff:0a:0a:06:1b
...
```

Use `dhcpcd` **DHCP client** to request a lease:

* Clear network interface configuration with `ip addr flush`
* **Request** an IP address white-listing the DHCP server at 10.1.1.5 with `-w`
* **Rebind** the interface before the lease expires with `-n`

```bash
>>> apt install dhcpcd5 # install a DHCP client
>>> ip addr flush ens3  # clear interface configuration 
>>> dhcpcd -B -W 10.1.1.5 -1 ens3
...
ens3: leased 10.1.1.27 for 43200 seconds
ens3: changing route to 10.1.1.0/24
ens3: changing default route via 10.1.1.1
...
>>> dhcpcd -d -B -W 10.1.1.5 -1 -n ens3
...
ens3: reading lease `/var/lib/dhcpcd5/dhcpcd-ens3.lease'
ens3: rebinding lease of 10.1.1.27
..
ens3: acknowledged 10.1.1.27 from 10.1.1.5
ens3: leased 10.1.1.27 for 43200 seconds
...
```
