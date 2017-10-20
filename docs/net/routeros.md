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
/system default-configuration print   # show default configuration
# reset the entire configuration (to start from scratch)
/system reset-configuration no-defaults=yes skip-backup=yes keep-users=no
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

### SSH

```bash
>>> /ip ssh print                               # show configuration
           forwarding-enabled: no
  always-allow-password-login: no
                strong-crypto: no
                host-key-size: 2048
## configure hard host keys
>>> /ip ssh set strong-crypto=yes
>>> /ip ssh set host-key-size=4096
>>> /ip ssh print                 
           forwarding-enabled: no
  always-allow-password-login: no
                strong-crypto: yes
                host-key-size: 4096
## generate hard host keys
>>> /ip ssh regenerate-host-key
>>> /system reboot 
```

