

## Time

Types of clocks:

* **RTC** (Real-Time Clock) aka hardware clock runs on battery when the machine is powered off (unplugged)
  - Uses _local time_ (in current time zone) 
  - Or **UTC** (Coordinated Universal Time) with an time zone dependent offset
* **SC** (Software Clock) aka system clock 
  - Maintained by the OS kernel during run-time driven by a timer interrupt
  - Initialized on boot using RTC as reference.


```bash
timedatectl                                 # show time and time zone configuration
timedatectl set-time YYYY-MM-DD             # change the current date
timedatectl set-time HH:MM:SS               # change the current time
timedatectl list-timezones                  # list available time zones
timedatectl set-timezone <zone>             # set a given time zone, e.g. Europe/Berlin
grep ^Servers /etc/systemd/timesyncd.conf   # list time servers 
timedatectl set-ntp true                    # enable NTP
timedatectl set-local-rtc 0                 # RTC in UTC mode
timedatectl set-local-rtc 1                 # RTC in locel time mode
systemctl start systemd-timesyncd           # start the time sync daemon 
systemctl enable systemd-timesyncd          # make the time sync daemon boot persistant 
```

Low-level administration tool

```bash
locale                                      # print locale settings
hwclock                                     # manipulate the hardware clock
/etc/adjtime                                # state file for hwclock
/usr/share/zoneinfo                         # time zone database
```
