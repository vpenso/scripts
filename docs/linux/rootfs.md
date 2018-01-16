# RootFS

The root file-system (rootfs) typically refers to the directory tree available in `/` (root path).

Following tools help to install a base operating system (OS) into a target directory:

* **debootstrap** - install a Debian in a sub-directory
* **multistrap** - like debootstrap, but supports multiple package repositories
* [polystrap](https://github.com/josch/polystrap) - creates a foreign architecture rootfs without superuser privileges
* **`yum`** (or `dnf`) with option `--installroot`


```bash
apt install debootstrap fakechroot fakeroot yum  # install the tool-chain on Debian
## install an OS based on Debian packages
debootstrap --include=linux-image-amd64 stretch $ROOTFS_PATH
fakeroot fakechroot /usr/sbin/debootstrap ...    # run debootstrap in user space
## install an OS based on RPM packages
yum -y --installroot=$ROOTFS_PATH --releasever=7 groupinstall 'Minimal Install'
```

### Customization

Work with the target directory:

```bash
fakeroot fakechroot chroot $ROOTFS_PATH          # run chroot in user space
chroot $ROOTFS_PATH /bin/bash                    # chroot into a shell
chroot $ROOTFS_PATH /bin/bash -c "<command>"     # execute a command in a chroot 
systemd-nspawn -D $ROOTFS_PATH "<command>"       # execute a command in a container execution rootfs
systemd-nspawn -b -D $ROOTFS_PATH                # boot the rootfs with a container
```

Basic customization for root file-system:

```bash
sed -i '/^root/ { s/:x:/::/ }' /etc/passwd       # remove the root password for tests
apt -y install zsh ; adduser --shell /bin/zsh devops
                                                 # add a test user devops
# -- configure the network interface -- ##
name=$(udevadm test /sys/class/net/* 2>&- | grep ID_NET_NAME_SLOT | cut -d= -f2)
                                                 # primary network interface
echo -e "[Match]\nName=$name\n[Network]\nDHCP=yes" > /etc/systemd/network/$name.network
systemctl restart systemd-networkd && systemctl enable systemd-networkd
echo $(mount | grep ' / ' | cut -d' ' -f1,3,5) defaults,noatime 0 1 > /etc/fstab
                                                 # configure root mount on boot
echo -e "domain devops.test\nsearch devops.test\nnameserver 10.1.1.1" > /etc/resolv.conf
                                                 # configure name resolution
```

## Images

### Raw 

* Plain binary image of the disk typically called **RAW**
* Allocate only used space on file-systems that support sparse files 
* GPT partition table with [Discoverable Partitions Specification](https://www.freedesktop.org/wiki/Specifications/DiscoverablePartitionsSpec/)

```bash
rfsimg=/tmp/rootfs.img rootfs=/mnt
dd bs=1M seek=4095 count=1 if=/dev/zero of=$rfsimg         # create a binary image
qemu-img create -f raw $rfsimg 100G                        # create a sparse binary image
## -- initalize a file-system (no partition table) -- ##
sudo mkfs.ext4 -F $rfsimg                                  # initialize a file-system
sudo mount -v -o loop $rfsimg $rootfs ; df -h $rootfs      # mount the disk image file
# work with the mount-point
sudo umount $rootfs
## -- GPT partition table -- ##
sgdisk -n 1:0M:+30G -t 1:4f68bce3-e8cd-4db1-96e7-fbcaf984b709 $rfsimg 
                                                           # GPT based partition
sgdisk -p -i 1 $rfsimg                                     # show configuration
kpartx -a -v $rfsimg && ls -l /dev/mapper/loop*            # add parition mapping
mkfs.ext4 /dev/mapper/loop0p1                              # create a file system, e.g. on the first partition
mount /dev/mapper/loop0p1 $rootfs                         
# work with the mount-point
umount $rootfs                          
kpartx -d -v $rfsimg                                       # remove partition mapping
```

### Qcow2

QEMU copy-on-write format supports: Snapshots, sparse images without file-system support, AES encryption

```bash
## -- qcow2 images with snapshot support -- ##
qemu-img create -f qcow2 <image> <size>                     # create a copy-on-write image file with size (e.g. 100G)
qemu-img info <image                                        # print details about a disk image
virt-format --partition=mbr --filesystem=ext4 -a <image>    # create a file-system in the image file
virt-ls -a <image> <path>                                   # list content of an image
virt-filesystems -lh --uuid -a <image>                      # list file-systems in image file
virt-copy-out -a <image> / <path>                           # copy image to local path
virt-tar-out -a <image> / - | gzip > <path>.tar.gz          # write disk image to zipped TAR archive
```

Use `qemu-nbd` to exports a disk image as a "network block device (nbd)":

```bash
sudo modprobe nbd max_part=16 ; lsmod | grep nbd # load the kernel module
sudo qemu-nbd -c /dev/nbd0 $rootfs 
sudo parted /dev/nbd0 print                      # show the partitions
sudo partprobe /dev/nbd0                         # expose the disk partitions, if missing
ls -a /dev/nbd0*                                 # list the devices created for each partition
sudo mount /dev/nbd0p? /mnt                      # mount a parititon, e.g. nbd0p1
## -- work with the mount-point -- ##
sudo umount /mnt
qemu-nbd -d /dev/nbd0                           
```

