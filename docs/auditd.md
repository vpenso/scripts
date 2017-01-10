
Create an audit trail, helping with the detection of security intrusion

```bash
/etc/audit/auditd.conf                   # daemon configuration
/etc/audit/audit.rules                   # persistant rules definition
dpkg -L auditd | grep example            # example rule sets
/var/log/audit/audit.log                 # log file (default)
auditctl                                 # command-line interface
         -s                              # show state
         -l                              # list rules
         -R <path>                       # read a rules definition file
aureport                                 # summery reports if audit.log
         -x --summary                    # summery for executables
         -au                             # authentication report
         -i -f                           # report file events
         -i -p                           # process related events
         -ts recent|today|week-ago|...   # limit report to time-frame
ausearch                                 # custom query to search audit.log
         -ul <name>                      # search a user
         -f                              # search for a file
         -m PATH|SYSCALL|USER_LOGIN      # search for a message type
         -p <pid>                        # search a process id
```

Operates on control, file-system and system-call rules defining changes to be logged, cf. `audit.rules`

