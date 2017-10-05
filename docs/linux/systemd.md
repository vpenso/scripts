
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
systemd --version                            # show systemd version
/etc/os-release                              # platform information
/etc/machine-id                              # unique machine identifier
man systemd.index                            # overview documentation
{/etc,/run,/lib}/systemd/system/             # unit configuration files
LESS="-p SIGNALS" man -P less systemd        # list of supported signals
LESS="-p KERNEL" man -P less systemd         # kernel command line options for boot
SYSTEMD_LESS=FRXMK                           # export to wrap lines to screen width
systemctl                                    # list all units with state
systemctl -t <unit_type>                     # list units with a given type, e.g. "service"
systemctl list-unit-files -t service         # list unit files for a given unit type 
systemctl cat <unit>                         # print unit configuration files
systemctl show <unit>                        # dump entire configuration
systemctl edit --full <unit>                 # edit a unit file, reload on close
systemctl reenable <unit>                    # reconfigure existing unit
systemctl --failed --all                     # list units in failed state
systemctl help <unit>
systemctl status [<unit>]                    # show state of a unit, e.g. ssh.service
systemctl is-enabled <unit>                  # check if a unit will bi started during init
systemctl is-active <unit>
systemctl list-dependencies <unit>           # show unit dependencies
systemctl start|stop|restart|reload <unit>   # state management of units
systemctl -t target                          # list available targets
systemctl get-default                        # show current default target at boot
systemctl set-default -f <target>            # set a new default target
systemctl show -p Wants <target>             # show dependencies to a target
systemctl isolate <target>                   # switch to another target
systemctl kill <service>                     # send TERM to service
systemctl kill -s <sig> <service>            # send a given signal to servive, e.g. HUB  
systemctl reboot|poweroff|suspend|hibernate  # power management
systemctl list-jobs                          # show pending jobs
systemctl daemon-reload                      # Re-read configuration files
systemctl daemon-reexec                      # re-execute systemd
/etc/systemd/system/<unit>.d/*.conf          # drop-in files to overwrite units
systemd-delta --type=extended                # Identify configuration which override others
systemd-analyze                              # time the system required during last booting
systemd-analyze blame                        # ^^ time by by unit
systemd-analyze critical-chain
```

Skeleton for a custom service unit `/lib/systemd/system/*.service` to execute a program once:

```
[Unit]
Description= # text

[Service]
Type=oneshot
ExecStart= # absolute path to program, arguments
```


## Network

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
Name=              # device name (e.g en*)

[Network]
Address=           # IP address, CIDR notation
Gateway=           # IP address
DNS=               # is a DNS server address (multiples possibel)
Domains=           # a list of the domains used for DNS host name resolution
```

Debugging `systemd-networkd`:

```bash
SYSTEMD_LOG_LEVEL=debug /lib/systemd/systemd-networkd   # execute with debugging in foreground
# Permanent by drop-in configuration
mkdir /etc/systemd/system/systemd-networkd.service.d/
echo -e "[Service]\nEnvironment=SYSTEMD_LOG_LEVEL=debug" > /etc/systemd/system/systemd-networkd.service.d/10-debug.conf 
systemctl daemon-reload && systemctl restart systemd-networkd
```

## Hostname

```bash
hostnamectl status                  # view hostname
hostnamectl set-hostname <fqdn>     # set hostname
hostnamectl set-hostname ""         # clear hostname
/etc/hostname                       # hostname configuration file
/etc/hosts                          # may contain FQDN of host (to be resolved without DNS)
dnsdomainname                       # display DNS domain name
domainname                          # (aka. nisdomainname) display NIS domain name
hostname                            # print hostname returned by the gethostname(2) function
hostname -s                         # print hostname cut at the first dot
hostname -f                         # print host FQDN
hostname -d                         # print host domain name
```

## Localization/Time

Settings system locale:

```bash
/etc/locale.conf                    # system-wide locale settings
localectl                           # show language configuration
localectl list-locales              # list vailable keys configuration
localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
localectl list-keymaps              # list all available keyboard layouts
localectl set-keymap us
```

Types of clocks:

* **RTC** (Real-Time Clock) aka hardware clock runs on battery during shutdown.
  - Uses _local time_ (in current time zone) 
  - Or **UTC** (Coordinated Universal Time) with an time zone dependent offset
* **SC** (Software Clock) aka system clock:
  - Maintained by the OS kernel during run-time.
  - Initialized on boot using RTC as reference.


```bash
timedatectl                                 # show time and time zone configuration
timedatectl set-time YYYY-MM-DD             # change the current date
timedatectl set-time HH:MM:SS               # change the current time
timedatectl list-timezones                  # list available time zones
timedatectl set-timezone <zone>             # set a given time zone, e.g. Europe/Berlin
grep ^Servers /etc/systemd/timesyncd.conf   # list time servers 
timedatectl set-ntp true                    # enable NTP
systemctl start systemd-timesyncd           # start the time sync daemon 
systemctl enable systemd-timesyncd          # make the time sync daemon boot persistant 
```


## Journal/Logging

```bash
man systemd-journald                  # docs for the journal daemon
systemctl status systemd-journald     # state of the journal service
man journald.conf                     # docs for the journald configuration
journalctl -b                         # this boot
journalctl -b -p err                  # error from this boot
journalctl -b -1                      # previous boot
journalctl --list-boots               # show list of boot logs
journalctl -k                         # kernel ring buffer
journalctl -f [...]                   # tail the log file
journalctl -u <unit>                  # messages of a specific unit
journalctl _UID=<uid>                 # messages by user ID
journalctl _PID=<pid>                 # messages from a given process
journalctl --since=yesterday
journalctl --since=00:00 --until=9:30
journalctl --since "20 min ago"
journalctl -o verbose -n
journalctl -f -l SYSLOG_FACILITY=10
journalctl --vacuum-time=2weeks       # clean journal files
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

## Timers

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


## Login Management

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

## File-System Mount

```bash
/etc/fstab                                      # translated by systemd-fstab-generator into units
/etc/systemd/system/*.mount                     # mount units
systemctl --all -t mount                        # show mounts
systemd.special                                 # units treated specially by systemd
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
WantedBy=local-fs.target
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
WantedBy=network-online.target
```

### Tmpfs

Use tmpfs to mount /tmp:

```bash
>>> cat /etc/systemd/system/tmp.mount
[Unit]
Description=Mount /tmp as tmpfs

[Mount]
What=tmpfs
Where=/tmp
Type=tmpfs
Options=rw,nodev,nosuid,size=2G

[Install]
WantedBy=basic.target
```



## Resource Limits

Enforce resource policies (CPU, RAM, I/O) for units with Linux Control Groups (cgroups)

```bash
man systemd.resource-control                      # documentation about resource limits
man systemd-system.conf                           # system wide defaults
systemd-cgtop                                     # enumerate all cgroups of the system including resource usage
systemd-cgls                                      # hierarchy of slices, scopes, and units  
```

Limits are defined in the service section:

```
[Service]
ControlGroupAttribute=               # e.g. memory.swappiness 70
CPUShares=<weight>                   # relative shares, e.g. 1024 (default)
CPUQuota=<perc>                      # time in percent, e.g. 20%
MemoryLimit=<bytes>                  # allocation limit, e.g. 1G
MemorySoftLimit=<bytes>              # suffix K, M, G, T
BlockIOWeight=<target> <weight>      # I/O bandwidth between 10 and 1000
```

## Containers

Cf. [bootstrap](bootstrap.md) to create root file-systems for containers

```bash
apt -y install systemd-container                 # install container support 
man systemd.nspaw                                # container settings documentation
{/etc,/run}/systemd/nspawn/*.nspawn              # nspawn container settings files
findmnt /var/lib/machines                        # container images & container settings
systemd-nspawn -D <rootfs>                       # chroot to container path
               -i <image>                        # chroot to a container image
               -b -D <rootfs>                    # boot container in path 
machinectl pull-raw --verify=no <url>            # download container archive 
           import-tar $archive                   # import rootfs from an archive
           list-images                           # list container images
           image-status <image>                  # status information about container image
           show-image <image>                    # properties of container image
           clone <src_image> <dst_image>         # clone a container image
           remove <image>                        # delete a continer image
           start <image>                         # start container
           list                                  # list running containers
           status <image>                        # process tree in container
           shell <user>@<image> /bin/bash        # start a shell in the container
           poweroff <image>                      # shutdown container
journalctl -M <image>                            # show log of container
```

Unit skeleton for a container in `/etc/systemd/system/${name}.service`

```
[Unit]
Description= # name of the container

[Service]
ExecStart=/usr/bin/systemd-nspawn -bD <rootfs>  # command to start the container           
```

Use a virtual ethernet interfaces:

```bash
echo -e "[Link]\nName=host0" > /etc/systemd/network/10-host0.link
echo -e "[Match]\nName=host0\n[Network]\nDHCP=yes" > /etc/systemd/network/11-host0.network
systemctl enable systemd-networkd                          # prepare the network configuration
## -- use a virtual network with a container -- ##
systemd-nspawn --network-veth --network-bridge=nbr0 ... 
```


