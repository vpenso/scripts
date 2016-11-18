
[LBNL Node Health Check (NHC)][01] periodically determines node(s) health

* Node(s) **drain** automatically with `reason="NHC: …"` on failing checks
* Node(s) **resume** automatically if all checks pass without failure


```bash
/etc/nhc/scripts/*.nhc                            # include files for checks
/etc/default/nhc                                  # default confgiuration
/etc/nhc/nhc.conf                                 # custom configuration file
/var/log/nhc.log                                  # log file
egrep -v '(^#|^$)' /etc/nhc/nhc.conf              # list all checks
nhc -l - -v -c /etc/nhc/nhc.conf                  # execute verbose
nhc -d -l - -t 0 MARK_OFFLINE=0                   # debugging, disable drain...
```

Integration with Slurm Cluster Scheduler:

```bash
>>> scontrol show config | grep HealthCheck
HealthCheckInterval     = 600 sec
HealthCheckNodeState    = ANY
HealthCheckProgram      = /usr/sbin/nhc
```



[01]: https://github.com/mej/nhc 
