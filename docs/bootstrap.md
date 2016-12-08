
## Images

```bash
## create and mount a RAW file system image -- ##
rfsimg=/tmp/rootfs.img                                     # root file-system image path
rootfs=/mnt                                                # path to mount root file-system
dd bs=1M seek=4095 count=1 if=/dev/zero of=$rfsimg         # create an disk image file
qemu-img create -f raw $rfsimg 100G                        # create sparse disk image file
sudo mkfs.ext4 -F $rfsimg                                  # initialize a file-system
sudo mount -v -o loop $rfsimg $rootfs ; df -h $rootfs      # mount the disk image file
## -- work with the mount-point -- ##
sudo umount $rootfs             
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

## Debootstrap

Create a minimal Debian container image with `debootstrap`

```bash
suite=testing ; rootfs=$suite ; archive=/tmp/debian-${suite}-$(date +%Y%m%dT%H%M%S).tar.gz
debootstrap $suite $rootfs && cd $rootfs ; tar -cvzf $archive .
                                                 # create an compressed archive 
            --include=linux-image-amd64 $suite $rootfs    
                                                 # include a kernel
chroot $rootfs /bin/bash -c "sed -i '/^root/ { s/:x:/::/ }' /etc/passwd"
                                                 # remove the root password for tests
```

Create a minimal Debian virtual machine image including bootloader:

```bash
cp -v $rootfs/boot/vmlinuz* /tmp/kern && cp -v $rootfs/boot/initrd* /tmp/init
                                                 # copy kernel and initramfs
kvm -nographic -kernel /tmp/kern -initrd /tmp/init -append "console=ttyS0 root=/dev/vda rw" \
    -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
                                                 # boot the configuration
name=$(udevadm test /sys/class/net/* 2>&- | grep ID_NET_NAME_SLOT | cut -d= -f2)
                                                 # primary network interface
echo -e "[Match]\nName=$name\n[Network]\nDHCP=yes" > /etc/systemd/network/$name.network
systemctl restart systemd-networkd && systemctl enable systemd-networkd
                                                 # configure systemd network
apt -y install grub2                             # install bootloader
echo $(mount | grep ' / ' | cut -d' ' -f1,3,5) defaults,noatime 0 1 > /etc/fstab
                                                 # configure root mount on boot
echo -e "domain devops.test\nsearch devops.test\nnameserver 10.1.1.1" > /etc/resolv.conf
                                                 # configure name resolution
kvm -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
                                                 # boot from the image
```



