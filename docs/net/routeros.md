# RouterOS

RouterOS is an operating system build buy MikroTik based on the Linux kernel:

* Wireless Access Point (HotSpot gateway)
* Web proxy, Socks proxy, DNS cache/proxy
* Stateful firewall
* S/D NAT (Network Address Translation)
* Routing (IPv4/6), RIPv1/2 OSPFv2/3, BGPv4
* VRF (Virtual Routing and Forwarding)
* MPLS (MultiProtocol Label Switching)
* VPN (Virtual Private Network) tunnels
* IPsec concentrator
* Intrusion detection system (IDS)
* Intrusion prevention system (IPS)

[MikroTik](https://mikrotik.com/products) RouterBoard hardware (consumers):

| Name         | Price | CPU    | RAM   | Ports | WLAN                          | USB | SFP | PoE        |
|--------------|-------|--------|-------|-------|-------------------------------|-----|-----|------------|
| mAP lite     | ~25   | 650Mhz |  64MB | 1xE   | 2.4GHz Dual-Chain             | no  | no  | 1x (in)    |
| mAP          | ~45   | 650Mhz |  64MB | 2xE   | 2.4GHz Dual-Chain             | no  | no  | 1x (in/out)|
| hAP mini     | ~20   | 650Mhz |  32MB | 3xE   | 2.4 GHz (802.11b/g/n)         | no  | no  | no         |
| hAP lite     | ~25   | 650Mhz |  32MB | 4xE   | 2.4 GHz (802.11b/g/n)         | no  | no  | no         |
| hAP          | ~45   | 650MHz |  64MB | 5xE   | 2.4 GHz (802.11b/g/n)         | yes | no  | 1x         |
| hAP AC lite  | ~50   | 650Mhz |  64MB | 4xE   | 2.4GHz/5GHz Dual-Concurrent   | yes | no  | 1x         |
| hAP AC       | ~130  | 720MHz | 128MB | 5xGE  | 2.4GHz/5GHz Dual-Concurrent   | yes | 1x  | 1x         |
| hEX lite     | ~40   | 850Mhz |  64MB | 5xE   | no                            | no  | no  | no         |
| hEX          | ~60   | 880Mhz | 256MB | 5xGE  | no                            | yes | no  | no         | 
| hEX PoE lite | ~60   | 650MHz |  64MB | 5xE   | no                            | no  | no  | 4x         |
| hEX PoE      | ~80   | 800Mhz | 128MB | 5xGE  | no                            | yes | 1x  | 4x         |

Management Tools:

* **Console** using serial port, telnet, SSH.
* **WebFig** web-interface over HTTP.
* **TikApp** Android mobile application.
* **WinBox** Windows GUI application (with WINE on Linux) over IP and MAC



## Console

First time setup:

* Reset configuration: hold reset button when applying power until LED starts flashing
* Factory pre-configured IP-address `192.168.88.1/24`(port 1), username `admin` (no password)
* Connect a computer on port 2/3/4 and login with `ssh admin@192.168.88.1`

The console allows configuration with text commands:

```bash
?                                     # list commands
<command> ?                           # show help for specific command
<command> print                       # information that's accessible from particular command level
/<command>                            # prefix to us a command at base-level
/quit                                 # close connection
```





## Configuration

Basic router configuration:

```bash
/system default-configuration print   # show default configuration
# reset the entire configuration (to start from scratch)
/system reset-configuration no-defaults=yes skip-backup=yes keep-users=no
# configure the time-zone
/system clock set time-zone-name=Europe/Berlin
# configure NTP servers
/system ntp client set server-dns-names="pool.ntp.org,time.google.com" enabled=yes
# configure the hostname
/system identity set name="<name>"
```

### Configuration Management

**Backup** stores the entire system configuration (assumes restore on the same hardware). The backup-file is encrypted by default (protected by password):

```bash
/system backup save name=<file>                # write a backup file
/system backup load name=<file>                # read a backup file
```

**Export** dumps a complete or partial configuration into a script file `*.rsc`:

```bash
/export compact                                # export non default configuration
/<command> export file=<name>                  # export a sub-system
/import file=<name>                            # import configuration
```

### License

RouterOS license levels: 0 (trial), 1 (demo), 3 to 6 

```bash
/system license print             # licensing information
```

Backup the license key:

```bash
/system license output            # dump license into a file
/file print                       # list available files, look file type .key
/file edit 1 value-name=contents  # show key in editor
# copy & paste to a save location
```

### Users

User management:

* Make sure to change the name and password of the `admin` (id: 0) account.
* Create separate accounts with `group=full` for admins.
* Read only user with `group=read`

```bash
/user print                                   # list user accounts
/user group print                             # list groups
/user active print                            # list logged-in users
/password                                     # set password for current user
/user set <name> password=<password>          # set password for user ID
/user set <id> name=<user>                    # change user name
# add a new user with admin priviliges
/user add name=<user> password=<password> group=full
/user disable [find name=<user>]              # disable a user
/user remove [find name=<user>]               # remove a user
```

### SSH Login

SSH server configuration:

* Enable strong cryptography, and use large keys
* Move the SSH service to a port different then 22

```bash
/ip ssh print                               # show configuration
/ip ssh set strong-crypto=yes               # configure hard host keys
/ip ssh set host-key-size=4096
/ip service set ssh port=2222               # do not use the default port
/ip ssh regenerate-host-key                 # generate hard host keys
```

Use an SSH private/public key-pair for login:

```bash
# upload an ssh public key
>>> scp -P 2222 id_rsa.pub 192.168.88.1:
# imported the public key for the login user
>>> ssh -p 2222 192.168.88.11 "/user ssh-keys import public-key-file=id_rsa.pub"
```


### Services

```bash
/ip service print                               # print list of services 
/ip service disable telnet,ftp,www,api,api-ssl  # disable a list of services
/ip service disable [find name!=ssh]            # disable all service except SSH
/ip service set address=192.168.0.0/16 [find]   # limit access to a CDIR
```

### Tools

```bash
/tool bandwidth-server set enabled=no       # disable bandwidth test server
/tool romon set enabled=no                  # disable RoMON
# collect network statistics
/tool graphing interface add allow-address=192.168.0.0/16
/tool graphing queue add allow-address=192.168.0.0/16
/tool graphing resource add allow-address=192.168.0.0/16
# disable MAC Telnet and MAC Winbox
/tool mac-server set [find] disabled=yes
/tool mac-server mac-winbox set [find] disabled=yes
/tool mac-server ping set enabled=no
```



## Operation

### Logging

Logging of system events and status information:

```bash
/log print                               # print log information
/log print follow where topics~"<name>"  # search for a specific topic
/system logging print                    # topic currently logged
/system logging add topics=<TAB>         # list available topics
/system logging add topics=<topic>       # enable logging for a given topic
```

### Packages

Update channels:

* **release** latest features (hardly tested)
* **current** latest stable version (very good tested)
* **bugfix** latest stable version including safe fixes

```bash
/system package print                         # list available packages
/system package update print                  # show update channel
/system package update set channel=current    # set update channel
/system package update check-for-updates      # check for updates
/system package update download               # download updates
/system reboot
/system routerboard upgrade                   # upgrade firmware
/system reboot
```

### Route

```bash
/ip route print                               # print routing table
```

### Interfaces


```bash
/interface print                              # list all interfaces (ethernet, wlan, etc.)
/interface print stats                        # all interfaces (packets, bytes, drops and errors)
/interface monitor-traffic <port>,aggregate   # traffic passing through a given interface
```

Ethernet port switching allows wire speed traffic passing among a group of ports:

* Ports are named `ether*`, typically ether1 is used for routing. 
* The **master port** will communicate to all ports in a group.

```bash
/interface ethernet switch print              # list switch chips
/interface ethernet switch host print         # switch chips internal mac address to port mapping
/interface ethernet print                     # list all ports
/interface ethernet monitor <port>            # link configuration of port
/interface ethernet enable|disable <name>     # enable, disable a port
/interface ethernet print stats               # tx/rx statistics
# port mirroring
/interface ethernet switch set <switch> mirror-source=<port> mirror-target=<port>
```

Ethernet VLAN management:

```bash
/interface vlan print                         # list VLANs
/interface ethernet switch port print         # vlan table forwarding rules
# specific VLAN IDs between ports
/interface ethernet switch vlan add ports=<port>[,<port>] switch=<switch> vlan-id=<id>
# VLAN per port configuration
/interface ethernet switch port set <port> 
     ... vlan-mode=secure                     # strict use of VLAN table
     ... vlan-header=always-strip             # remove VLAN header from frame
     ..  vlan-header=add-if-missing           # adds VLAN header to untagged frames
     ... default-vlan-id=<id>                 # set default VLAN ID
```
### Wireless

```bash
/interface wireless print                     # configuration
/interface wireless security-profiles print   # security configuration
/interface wireless set <name> disabled=yes   # disable WLAN
## specify a password for wireless access
/interface wireless security-profiles set default authentication-types=wpa2-psk 
mode=dynamic-keys wpa2-pre-shared-key=<password>
```

