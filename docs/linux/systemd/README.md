
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

### Hostname

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
