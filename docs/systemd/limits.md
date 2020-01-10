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
