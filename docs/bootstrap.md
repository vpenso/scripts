
Etcher writes image files to USB drives and SD cards:

<https://etcher.io/>

## Images

### Raw 

* Plain binary image of the disk typically called **RAW**
* Allocate only used space on file-systems that support sparse files 
* GPT partition table with [Discoverable Partitions Specification](https://www.freedesktop.org/wiki/Specifications/DiscoverablePartitionsSpec/)

```
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
rfsimg=/tmp/rootfs.img rootfs=/mnt
## -- qcow2 images with snapshot support -- ##
qemu-img create -f qcow2 $rfsimg 100G            # create a copy-on-write image file
qemu-img info $rfsimg                            # print details about a disk image
virt-format --partition=mbr --filesystem=ext4 -a $rfsimg         
                                                 # create a file-system in the image file
virt-filesystems -lh --uuid -a $rfsimg           # list file-systems in image file
sudo guestmount --rw -a $rfsimg -m /dev/sda1 $rootfs -o dev ; mount | grep $rootfs
## -- work with the mount-point -- ##
sudo guestunmount $rootfs
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

## Debootstrap

Create a minimal Debian container image with `debootstrap`

```bash
apt install debootstrap fakechroot fakeroot      
suite=testing ; rootfs=$suite ; archive=/tmp/debian-${suite}-$(date +%Y%m%dT%H%M%S).tar.gz
fakeroot fakechroot /usr/sbin/debootstrap ...    # run debootstrap in user space
debootstrap $suite $rootfs && cd $rootfs ; tar -cvzf $archive .
                                                 # create an compressed archive 
            --include=linux-image-amd64 $suite $rootfs    
                                                 # include a kernel
## -- Work with the root file-system -- ##
fakeroot fakechroot chroot ...                   # run chroot in user space
chroot $rootfs /bin/bash                         # chroot into a shell
chroot $rootfs /bin/bash -c "<command>"          # execute a command in a chroot 
```

Boot a root file-system with `kvm`:

```bash
# -- boot a VM with rootfs and external kernel & initrd -- ##
cp -v $rootfs/boot/vmlinuz* /tmp/kern && cp -v $rootfs/boot/initrd* /tmp/init
kvm -nographic -kernel /tmp/kern -initrd /tmp/init -append "console=ttyS0 root=/dev/vda rw" \
    -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
# -- boot a VM from an image bootloader -- ##
kvm -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
```

Basic customization for root file-system:

```bash
sed -i '/^root/ { s/:x:/::/ }' /etc/passwd"      # remove the root password for tests
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
