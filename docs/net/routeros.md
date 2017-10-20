## RouterOS

[MikroTik RouterOS Manual](https://wiki.mikrotik.com/wiki/Manual:TOC)

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

Collect network statistics:

```bash
/tool graphing interface add allow-address=192.168.0.0/16
/tool graphing queue add allow-address=192.168.0.0/16
/tool graphing resource add allow-address=192.168.0.0/16
```

### Users & Logins

```bash
/user print                                   # list user accounts
/user active print                            # list logged-in users
/password                                     # set password fot current user
```

Harden the SSH server: 

```bash
>>> /ip ssh print                               # show configuration
           forwarding-enabled: no
  always-allow-password-login: no
                strong-crypto: no
                host-key-size: 2048
## configure hard host keys
>>> /ip ssh set strong-crypto=yes
>>> /ip ssh set host-key-size=4096
>>> /ip ssh regenerate-host-key                 # generate hard host keys
>>> /system reboot 
```

### Services


```bash
/ip service print                               # print list of services 
/ip service disable [find name!=ssh]            # disable all service except SSH
/ip service set address=192.168.0.0/16 [find]   # limit access to a CDIR
```
