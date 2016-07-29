
# Systemd

- First process executed in users space (PID 1)
- Initialize user-space, and provides dependency management between **units**
- Each Unit is describes with a configuration file, the suffix determines the unit type
- **Targets** define a group of units (like run levels), may inherit services from another target
- **Scopes** are groups of processes registered using the runtime APIs (e.g. containers).
- **Slices** are hierarchies of services/scopes (contain processes) 
- Slices inherit resource limits to descendants, `-.slice` root slice, `system.slice` default slice
- Every process is spawned in a **control group** named after its service.
- **Timers** `.timer` control services or events (similar to cron) supporting calender/monotonic time 

```bash
man systemd.unit                                # show documentation about systemd units
systemctl                                       # list all units with state
systemctl -t <unit_type>                        # list units with a given type, e.g. "service"
ls -l {/etc,/run,/lib}/systemd/system           # list unit configuration files
systemctl --failed --all                        # list units in failed state
systemctl help <unit>
systemctl status [<unit>]                       # show state of a unit, e.g. ssh.service
systemctl is-enabled <unit>                     # check if a unit will bi started during init
systemctl is-active <unit>
systemctl list-dependencies <unit>              # show unit dependencies
systemctl [start|stop|restart|reload] <unit>    # state management of units
systemctl -t target                             # list available targets
systemctl get-default                           # show current default target at boot
systemctl set-default -f <target>               # set a new default target
systemctl show -p Wants <target>                # show dependencies to a target
systemctl isolate <target>                      # switch to another target
systemctl kill <service>                        # send TERM to service
systemctl kill -s <sig> <service>               # send a given signal to servive, e.g. HUB  
systemctl reboot|poweroff|suspend|hibernate     # power management
systemctl list-jobs                             # show pending jobs
systemctl daemon-reexec                         # re-execute systemd
```

```bash
man systemd.timer
systemctl list-timers --all                     # list all timers, including inactive
systemd-run --on-active=30 <command>            # transient .timer unit executes a command
systemd-run --on-active=<time> --unit <unit>    # transient .timer unit executes unit
apt install systemd-cron                        # systemd units to run cron scripts
```

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

```bash
SYSTEMD_LESS=FRXMK                              # Wrap line to screen width
journalctl -b                                   # this boot
journalctl -b -p err                            # error from this boot
journalctl -b -1                                # previous boot
journalctl -k                                   # kernel ring buffer
journalctl -f                                   # tail the log file
journalctl -u <unit>                            # messages of a specific unit
journalctl _UID=<uid>                           # messages by user ID
journalctl _PID=<pid>                           # messages from a given process
journalctl --since=yesterday
journalctl --since=00:00 --until=9:30
journalctl --since "20 min ago"
journalctl -o verbose -n
journalctl -f -l SYSLOG_FACILITY=10
journalctl --vacuum-time=2weeks                 # clean journal files
man systemd-journald                            # documentation for the journal daemon
systemctl status systemd-journald               # state of the journal service
man journald.conf                               # documenation for the journal service 
```


