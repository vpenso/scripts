
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
dd if=/dev/zero bs=512 count=1 of=<device>     # wipe the bootsector of a devices
parted -l                                      # list devices/partitons
parted <device> print free                     # show free strorage on device
parted <device> mkpart primary <start> <end>   # create primary partiton
parted <device> rm <number>                    # delete partition
/proc/partitions
file -s <device>                               # read partition info from device
```

### File-Systems

```bash
mkfs.<type> <partition>                   # init fs on partition
mount -o umask=000 <device> <mnt-point>   # mount a USB stick readable for all
/proc/self/mountinfo                      # mount information
findmnt                                   # show tree all file systems
findmnt -l                                # list all file systems
findmnt -D                                # output like df
findmnt -s                                # from /etc/fstab
findmnt -S /dev/<device>                  # by source device
findmnt -T <path>                         # by mount point
findmnt -t <type>,...                     # by type, e.g. nfs
```

