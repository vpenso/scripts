
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
