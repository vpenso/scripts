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
