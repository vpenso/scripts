
## Images

```bash
qemu-img info <image>                                      # print details about a disk image
```


### Raw

```
rootfs=/tmp/rootfs.img
dd bs=1M seek=4095 count=1 if=/dev/zero of=$rootfs         # create an disk image file
qemu-img create -f raw $rootfs 100G                        # create sparse disk image file
sudo mkfs.ext4 -F $rootfs                                  # initialize a file-system
sudo mount -v -o loop $rootfs /mnt ; df -h /mnt            # mount the disk image file
## -- work with the mount-point -- ##
sudo umount /mnt                                           
```

### Qcow2

Adds an over-layer to support snapshots among other features

```bash
qemu-img create -f qcow2 $rootfs 100G            # create a copy-on-write image file
virt-format --partition=mbr --filesystem=ext4 -a $rootfs         
                                                 # create a file-system in the image file
virt-filesystems -lh --uuid -a $rootfs           # list file-systems in image file
sudo guestmount --rw -a $rootfs -m /dev/sda1 /mnt -o dev ; mount | grep /mnt
## -- work with the mount-point -- ##
sudo guestunmount /mnt
```

Alternatively use `qemu-nbd` to exports a disk image as a "network block device (nbd)":

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

## Bootstrap

Bootstrap the operating system Debian

```bash
sudo debootstrap --include=linux-image-amd64 testing /mnt  # minimal Debian testing user space
sudo chroot /mnt /bin/bash -c "sed -i '/^root/ { s/:x:/::/ }' /etc/passwd"
                                                           # remove the root password
cp -v /mnt/boot/vmlinuz* /tmp/kern && cp -v /mnt/boot/initrd* /tmp/init
                                                           # copy kernel and initramfs
kvm -nographic -kernel /tmp/kern -initrd /tmp/init -append "console=ttyS0 root=/dev/vda rw" \
    -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
                                                           # boot the configuration
name=$(udevadm test /sys/class/net/* 2>&- | grep ID_NET_NAME_SLOT | cut -d= -f2)
                                                           # primary network interface
echo -e "[Match]\nName=$name\n[Network]\nDHCP=yes" > /etc/systemd/network/$name.network
systemctl restart systemd-networkd && systemctl enable systemd-networkd
                                                           # configure systemd network
apt -y install grub2                                       # install bootloader
echo $(mount | grep ' / ' | cut -d' ' -f1,3,5) defaults,noatime 0 1 > /etc/fstab
                                                           # configure root mount on boot
echo -e "domain devops.test\nsearch devops.test\nnameserver 10.1.1.1" > /etc/resolv.conf
                                                           # configure name resolution
kvm -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
                                                           # boot from the image
```
