## RouterOS

* [MikroTik](https://mikrotik.com/products) RouterBoards 
* [RouterOS Manual](https://wiki.mikrotik.com/wiki/Manual:TOC)

(WLAN) Router:

| Name         | Price | CPU    | RAM   | Ports | WLAN                          | USB | SFP | PoE        |
|--------------|-------|--------|-------|-------|-------------------------------|-----|-----|------------|
| mAP lite     | ~25   | 650Mhz |  64MB | 1xE   | Dual-Chain 2.4GHz             | no  | no  | 1x (in)    |
| mAP          | ~45   | 650Mhz |  64MB | 2xE   | Dual-Chain 2.4GHz             | no  | no  | 1x (in/out)
| hAP mini     | ~20   | 650Mhz |  32MB | 3xE   | 2.4 GHz (802.11b/g/n)         | no  | no  | no         |
| hAP lite     | ~25   | 650Mhz |  32MB | 4xE   | 2.4 GHz (802.11b/g/n)         | no  | no  | no         |
| hAP          | ~45   | 650MHz |  64MB | 5xE   | 2.4 GHz (802.11b/g/n)         | yes | no  | 1x         |
| hAP AC lite  | ~50   | 650Mhz |  64MB | 4xE   | Dual-Concurrent 2.4GHz/5GHz   | yes | no  | 1x         |
| hAP AC       | ~130  | 720MHz | 128MB | 5xG E | Dual-Concurrent 2.4GHz/5GHz   | yes | 1x  | 1x         |
| hEX lite     | ~40   | 850Mhz |  64MB | 5xE  | no                             | no  | no  | no         |
| hEX          | ~60   | 880Mhz | 256MB | 5xGE | no                             | yes | no  | no         | 
| hEX PoE lite | ~60   | 650MHz |  64MB | 5xE  | no                             | no  | no  | 4x         |
| hEX PoE      | ~80   | 800Mhz | 128MB | 5xGE | no                             | yes | 1x  | 4x         |

## Console

Most basic setup steps:

* Connect the uplink (WAN/LAN) to port 1, and a node to any other port
* Default IP-address of the router is **192.168.88.1**
* Login with `ssh admin@192.168.88.1` (no password required)

The console allows configuration with text commands:

```bash
?                                     # list commands
<command> ?                           # show help for specific command
<command> print                       # information that's accessible from particular command level
/<command>                            # prefix to us a command at base-level
/quit                                 # close connection
```

Logging:

```bash
/log print                               # print log information
/log print follow where topics~"<name>"  # search for a specific topic
/system logging add topics=<TAB>         # list available topics
# enable logging for a given topic
/system logging add topics=<topic> action=memory
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

Backup the configuration

```bash
/system backup save name=config                # write a backup file
/file print detail where name="config.backup"  # show backup file time stamp
/export compact                                # 
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

### Users & Logins

User management:

* Make sure to change the name and password of the `admin` (id: 0) account.
* Create a secondary user account with with `group=full`

```bash
/user print                                   # list user accounts
/user active print                            # list logged-in users
/password                                     # set password for current user
/user set <id> password=<password>            # set password for user ID
/user set <id> name=<user>                    # change user name
# add a new user with admin priviliges
/user add name=<user> password=<password> group=full
/user disable [find name=<user>]              # disable a user
/user remove [find name=<user>]               # remove a user
```

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


### Packages

Update the OS:

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
/interface print                              # print ports
/interface set <id>[,<id>,...] disabled=yes   # disable a list of ports
```

### WLAN

```bash
/interface wireless print                     # configuration
/interface wireless security-profiles print   # security configuration
```

