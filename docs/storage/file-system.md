
```bash
/proc/filesystems                         # list of supported file-systems
/proc/self/mountinfo                      # mount information
lsblk -f                                  # list block devices with file-system type
```

Format a partition with a specific file-system:

```
mkfs.$type $partition                     # init fs on partition
mkfs.ext4 /dev/sdb1
```

