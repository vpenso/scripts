List mounted file systems

```bash
findmnt                                   # show tree all file systems
findmnt -l                                # list all file systems
findmnt -D                                # output like df
findmnt -s                                # from /etc/fstab
findmnt -S /dev/<device>                  # by source device
findmnt -T <path>                         # by mount point
findmnt -t <type>,...                     # by type, e.g. nfs
```

Mount a file-system:

```bash
sudo mount $partition $mntpoint    # mount filesystem located on a device partition
```
