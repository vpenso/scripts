
Prepare a `rootfs` file-system disk image:

```
rootfs=/tmp/rootfs.img
dd bs=1M seek=4095 count=1 if=/dev/zero of=$rootfs         # crate an disk image file
qemu-img create -f raw $rootfs 100G                        # sparse disk image file
sudo mkfs.ext4 -F $rootfs                                  # initialize a file-system
sudo mount -v -o loop $rootfs /mnt ; df -h /mnt            # mount the disk image file
## -- work with the mount-point -- ##
sudo umount /mnt                                           
```

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
kvm -drive file=$rootfs,if=virtio -netdev user,id=net0 -device virtio-net-pci,netdev=net0
                                                           # boot from the image
```
