

```bash
zpool status [<name>]                  # show storage pools
zpool scrub <name>                     
zpool create <name> <type> <device> [<device>,...]
                                       # create a new storage pool
```

Pool type in oder of performance:

- `mirror` – More disks, more reliability, same capacity. (RAID 1)
- `raidz1` – Single parity, minimum 3 disks. Two disk failures results in data loss.
- `raidz2` – Dual parity, minimum 4 disks. Allows for two disk failures.
- `raidz3` – Triple parity, minimum 5 disks. Allows for three disk failures.

```bash
zfs list [<name>]                      # show file-systems
zfs set mountpoint=<path> <name>       # set target mount point for file-system 
zfs mount <name>                       # mount a file-system
zfs umount <path>                      # unmount a file-system
grep -i mount= /etc/default/zfs        # boot persistance
findmnt -t zfs                         # list mounted file-systems
zfs list -o quota <name>               # show quota for file-system
zfs set quota=<size> <name>            # set quota for file-system
```
