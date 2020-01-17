
```bash
hwinfo --disk
fdisk -l
smartctl -a /dev/sda
/proc/partitions
parted -l | grep '^Disk /dev'
lspci | egrep "RAID|SATA"
dmesg | grep ata[0-9] | tr -s ' ' | cut -d' ' -f3- | sort
lshw -class disk                          # show disk configuration
lshw -class tape -class disk -class storage -short
                                          # show all storage resources
```

### Block Devices

```bash
lsblk                                      # show block device
lsblk -o KNAME,TYPE,SIZE,MODEL             # show block device model              
ls -l /dev/[vsh]d* | grep disk             # list device files
/sys/dev/block/                            # devices with major:minor device numbers
dmesg | grep '[vsh][dr][a-z][1-9]' | tr -s ' ' | cut -d' ' -f3-
                                           # kernel boot messages
blkid | sort                               # block device unique IDs
hdparm -I <device>                         # get device parameters
hdparm -r0|1 <device>                      # toggle write protection
```

### Partitions

```bash
/proc/partitions
file -s <device>                               # read partition info from device
dd if=/dev/zero bs=512 count=1 of=<device>     # wipe the bootsector of a devices
```

```bash
parted -l                                      # list devices/partitons
parted $device mklabel msdos                   # Master Boot Record/MS-DOS partition table
parted $deviec mklabel gpt                     # GUID Partition Table
parted $device print free                     # show free strorage on device
# create single partiton using the entire device
parted -a optimal $device mkpart primary 0% 100%
parted $device rm $number                      # delete partition
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

