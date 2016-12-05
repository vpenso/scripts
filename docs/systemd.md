
# Systemd

First process executed in users space (PID 1)

- Initialize user-space, and provides dependency management between **units**
- Each Unit is describes with a configuration file, the suffix determines the unit type `unit_name.type_extensiona`. cf. `systemd.unit`
- **Targets** define a group of units (like run levels), may inherit services from another target
- **Scopes** are groups of processes registered using the runtime APIs (e.g. containers).
- **Slices** are hierarchies of services/scopes (contain processes) 
- Slices inherit resource limits to descendants, `-.slice` root slice, `system.slice` default slice
- Every process is spawned in a **control group** named after its service.

```bash
systemd --version                               # show systemd version
/etc/os-release                                 # platform information
/etc/machine-id                                 # unique machine identifier
man systemd.index                               # overview documentation
{/etc,/run,/lib}/systemd/system/                # unit configuration files
LESS="-p SIGNALS" man -P less systemd           # list of supported signals
LESS="-p KERNEL" man -P less systemd            # kernel command line options for boot
SYSTEMD_LESS=FRXMK                              # export to wrap lines to screen width
systemctl                                       # list all units with state
systemctl -t <unit_type>                        # list units with a given type, e.g. "service"
systemctl list-unit-files -t service            # list unit files for a given unit type 
systemctl cat <unit>                            # print unit configuration files
systemctl edit --full <unit>                    # edit a unit file, reload on close
systemctl reenable <unit>                       # reconfigure existing unit
systemctl --failed --all                        # list units in failed state
systemctl help <unit>
systemctl status [<unit>]                       # show state of a unit, e.g. ssh.service
systemctl is-enabled <unit>                     # check if a unit will bi started during init
systemctl is-active <unit>
systemctl list-dependencies <unit>              # show unit dependencies
systemctl start|stop|restart|reload <unit>      # state management of units
systemctl -t target                             # list available targets
systemctl get-default                           # show current default target at boot
systemctl set-default -f <target>               # set a new default target
systemctl show -p Wants <target>                # show dependencies to a target
systemctl isolate <target>                      # switch to another target
systemctl kill <service>                        # send TERM to service
systemctl kill -s <sig> <service>               # send a given signal to servive, e.g. HUB  
systemctl reboot|poweroff|suspend|hibernate     # power management
systemctl list-jobs                             # show pending jobs
systemctl daemon-reload                         # Re-read configuration files
systemctl daemon-reexec                         # re-execute systemd
/etc/systemd/system/<unit>.d/*.conf             # drop-in files to overwrite units
systemd-delta --type=extended                   # Identify configuration which override others
systemd-analyze                                 # time the system required during last booting
systemd-analyze blame                           # ^^ time by by unit
systemd-analyze critical-chain                  
```

### Network

**Predictable interface names** prefix `en` Ethernet `wl` WLAN with following types:

```
o<index>                                                         on-board device index number
s<slot>[f<function>][d<dev_id>]                                  hotplug slot index number
x<MAC>                                                           MAC address
p<bus>s<slot>[f<function>][d<dev_id>]                            PCI geographical location
p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>] USB port number chain
```

ref. `/lib/udev/rules.d/80-net-setup-link.rules`, cf. `systemd.link`

```bash
udevadm info -e | grep -A 9 ^P.*en[sop]          # dump udev database and grep for ethernet
udevadm test /sys/class/net/* 2>&- | grep ID_NET_NAME_
## -- .link file are used to rename an interface -- ##
ls -l {/etc,/run,/lib}/systemd/network/*.link    # list link configuration files
ip -o -4 link                                    # show link state
```

Configure the network, cf. `systemd.network`

```bash
ls -l {/etc,/run,/lib}/systemd/network/*.network # network configuration 
networkctl list                                  # list network connections
networkctl status                                # show IP addresses for interfaces
```

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
Name=                              # device name (e.g en*)

[Network]
Address=                           # IP address, CIDR notation
Gateway=                           # IP address
DNS=                               # is a DNS server address (multiples possibel)
Domains=                           # a list of the domains used for DNS host name resolution
```

Debugging `systemd-networkd`:

```bash
SYSTEMD_LOG_LEVEL=debug /lib/systemd/systemd-networkd   # execute with debugging in foreground
# Permanent by drop-in configuration
mkdir /etc/systemd/system/systemd-networkd.service.d/
echo -e "[Service]\nEnvironment=SYSTEMD_LOG_LEVEL=debug" > /etc/systemd/system/systemd-networkd.service.d/10-debug.conf 
systemctl daemon-reload && systemctl restart systemd-networkd
```



### Localization/Time

```bash
timedatectl                                     # show time and time zone configuration
timedatectl list-timezones                      # list available time zones
timedatectl set-timezone <zone>                 # set a given time zone, e.g. Europe/Berlin
grep ^Servers /etc/systemd/timesyncd.conf       # list time servers 
timedatectl set-ntp true                        # enable NTP
systemctl start systemd-timesyncd               # start the time sync daemon 
systemctl enable systemd-timesyncd              # make the time sync daemon boot persistant 
localectl                                       # show language configuration
localectl list-locales                          # list vailable keys configuration
localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
```

### Journal/Logging

```bash
man systemd-journald                            # docs for the journal daemon
systemctl status systemd-journald               # state of the journal service
man journald.conf                               # docs for the journald configuration
journalctl -b                                   # this boot
journalctl -b -p err                            # error from this boot
journalctl -b -1                                # previous boot
journalctl --list-boots                         # show list of boot logs
journalctl -k                                   # kernel ring buffer
journalctl -f [...]                             # tail the log file
journalctl -u <unit>                            # messages of a specific unit
journalctl _UID=<uid>                           # messages by user ID
journalctl _PID=<pid>                           # messages from a given process
journalctl --since=yesterday
journalctl --since=00:00 --until=9:30
journalctl --since "20 min ago"
journalctl -o verbose -n
journalctl -f -l SYSLOG_FACILITY=10
journalctl --vacuum-time=2weeks                 # clean journal files
```

Enable the persistent storage of log messages

```bash
mkdir /etc/systemd/journald.conf.d
echo -e "[Journal]\nStorage=persistent" > /etc/systemd/journald.conf.d/storage.conf
# enable this change without reboot...
systemd-tmpfiles --create --prefix /var/log/journal
systemctl restart systemd-journald
```

Forward messages to a central log server with `syslog-ng` 

```bash
echo -e "[Journal]\nForwardToSyslog=yes" > /etc/systemd/journald.conf.d/forward_syslog.conf
```


### Timers

Timers `.timer` control services or events (similar to Cron) supporting calender/monotonic time 

```bash
man systemd.timer
systemctl list-timers --all                     # list all timers, including inactive
systemd-run --on-active=30 <command>            # transient .timer unit executes a command
systemd-run --on-active=<time> --unit <unit>    # transient .timer unit executes unit
apt install systemd-cron                        # systemd units to run cron scripts
```

Cleaning Temporary Directories

```bash
man 5 tmpfiles.d                                # documentation manual
{/etc,/run,/usr/lib}/tmpfiles.d/*.conf          # configuraion path
systemctl status systemd-tmpfiles-clean.timer   # timer state
```


### Login Management

```bash
systemctl status systemd-logind.service         # state of the login manager
man logind.conf                                 # login manager configuration
```

`pam_systemd` registers user sessions with the systemd login manager

```bash
apt install libpam-systemd                      # install PAM support for systemd
grep pam_systemd.so /etc/pam.d/*                # PAM configuration for systemd
systemctl status dbus.service                   # DBus is required by pam_systemd.so
```
All user sessions `session-<id>.scope` of belong to a slice `user-<uid>.slice` below the `user.slice`

```bash
loginctl [list-users]                           # list users
loginctl user-status <user>                     # show run-time information of user
loginctl terminate-user <user>                  # terminate all user sessions
loginctl list-seats                             # list seats
loginctl seat-status <seat>                     # list devices associated to seat
ls ~<user>/.config/systemd/user                 # unit files for a given user
loginctl enable-linger <user>                   # make user sessions (boot) persistant    
```

### File-System Mount

```bash
/etc/fstab                                      # translated by systemd-fstab-generator into units
/etc/systemd/system/*.mount                     # mount units
systemctl --all -t mount                        # show mounts
systemctl daemon-reload && systemctl start <name>.mount
                                                # mount with a unit file
```

Mount units must be named after the mount point directories they control, cf `systemd-escape`.

Unit skeleton for a local file-system:

```
[Unit]
Description= # comment

[Mount]
What= # partition name, path or UUID to mount
Where= # path to a mount point
Type= # file system type (e.g. ext4)
Options=defaults

[Install]
WantedBy=multi-user.target
```

Unit skeleton for an NFS mount:

```
[Unit]
Description= # comment
Wants=network-online.target
After=network-online.target

[Mount]
What= # path uuid, e.g. nfs.devops.test:/srv/nfs/devops
Where= # path to a mount point
Type=nfs4
Options=defaults
TimeoutSec=10s

[Install]
WantedBy=multi-user.target
```


