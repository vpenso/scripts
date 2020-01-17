List file systems mounted on the system:

```bash
findmnt                                   # show tree all file systems
findmnt -l                                # list all file systems
findmnt -D                                # output like df
findmnt -s                                # from /etc/fstab
findmnt -S /dev/<device>                  # by source device
findmnt -T <path>                         # by mount point
findmnt -t <type>,...                     # by type, e.g. nfs
```

Mount a partition from a storage device:

```bash
sudo mount $partition $mntpoint    # mount filesystem located on a device partition
```

## Removable Devices

Mount a hot-plug devices like a USB drive as normal user:

```bash
sudo apt install -y pmount
pmount ${device:-/dev/sdb1} ${label:-storage}
pumount $device
```

The device partition is mounted below `/media/$label`
