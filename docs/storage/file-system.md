
```bash
/proc/filesystems                         # list of supported file-systems
/proc/self/mountinfo                      # mount information
lsblk -f                                  # list block devices with file-system type
```

Format a partition with a specific file-system:

```bash
mkfs.$type $partition                     # init fs on partition
mkfs.ext4 /dev/sdb1
```

File system type can have a **label**:

```bash
/dev/disk/by-label                        # list of devices partiions by label
mkfs.$type -L $label ...                  # add a file-system label
# set the file-system label on ext{2,3,4} file-system type partition 
e2label ${part:-/dev/sda1} ${label:-root}
tune2fs -L ${label:-root} ${part:-/dev/sda1}
# change the label of an exFAT formated partition
exfatlabel ${part:-/dev/sdc1} ${label:-usb}
```

Multi user support with ACLs:

```bash
mnt=/mnt                      # mount point within the root files-ystem
part=/dev/sdc1                # for example, change this to your needs!
mkfs.ext4 $part               # create a file-system with ACL support
tune2fs -o acl $part          # enable ACLs
mount $part $mnt              # mount the partition
chown $user: $mnt
chmod 777 $mnt
setfacl -m d:u::rwx,d:g::rwx,d:o::rwx $mnt
umount $mnt
```
