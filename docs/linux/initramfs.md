Cf. [kernel](kernel.md) to build a custom Linux kernel.

# Initramfs Infrastructure 

RAM-based file-system, cf. [ramfs, rootfs and initramfs](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)

* **ramdisk** - Fixed size synthetic block device in RAM backing a file-system (requires a corresponding file-system driver).
* **ramfs** - Dynamically resizable RAM file-system (without a backing block device).
* **tmpfs** - Derivative of ramfs with size limits and swap support.
* **rootfs** - Kernel entry point for the root file-system storage initialized as ramfs/tmpfs. During boot early user-space usually mounts a target root file-system to the kernel rootfs.

The **initramfs** (aka. **initrd** (init ram-disk)) is a compressed CPIO formatted file-system archive extracted into rootfs during kernel boot. Contains an "init" file and the early user-space tools to enable the mount of a target root file-system.

```bash
>>> file initrd.img
initrd.img: XZ compressed data
# extract the archive and restore the CPIO formated file-system
>>> xz -dc < initrd.img | cpio --quiet -i --make-directories
# create a CPIO formated file-system, and compress it
>>> find . 2>/dev/null | cpio --quiet -c -o | xz -9 --format=lzma >"new_initrd.img"
```

Initramfs is loaded to (volatile) memory during Linux boot and used as intermediate root file-system, aka. **early user-space**:

* Prepares device drivers required to mount the **final/target root file-system** (rootfs) if is loaded:
  - ...by addressing a local disk (block device) by label or UUID
  - ...from the network (NFS, iSCSI, NBD)
  - ...from a logical volume LVM, software (ATA)RAID `dmraid`, device mapper multi-pathing
  - ...from an encrypted source `dm-crypt`
  - ...live system on `squashfs` or `iso9660`
* Provides a minimalistic rescue shell
* Mounted by the kernel to `/` if present, before executing `/init` main init process (PID 1)

## Linux Kernel Support

Enable support in the Linux kernel configuration:

```bash
>>> grep -e BLK_DEV_INITRD -e BLK_DEV_RAM -e TMPFS -e INITRAMFS $kernel/linux.config
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_INITRAMFS_COMPRESSION=".gz"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
```

## Building Initramfs

Tools helping build an initramfs image:

* [dracut](centos/dracut.md)
* [initramfs-tools](debian/initramfs-tools.md)
* [mkinitcpio](https://git.archlinux.org/mkinitcpio.git/)
* [mkinitramfs-II](https://github.com/tokiclover/mkinitramfs-ll)
* [tiny-initramfs](https://github.com/chris-se/tiny-initramfs/)
* [init4boot](https://github.com/florath/init4boot)

### C Program

Simple C program execute as initrd payload:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/reboot.h>

int main(void) {
    printf("Hello, world!\n");
    reboot(0x4321fedc);
    return 0;
}
```
```bash
# compile the program
>>> gcc -o initrd/init -static init.c
# create a CPIO formated file-system, and compress it
>>> ( cd initrd/ && find . | cpio -o -H newc ) | gzip > initrd.gz
# test in a virtual machine
>>> kvm -m 2048 -kernel ${KERNEL}/${version}/linux -initrd initrd.gz -append "debug console=ttyS0" -nographic
```

### BusyBox

Download the latest BusyBox from [busybox.net](https://busybox.net/downloads/)

```bash
### Download and extract busybox
>>> version=1.26.2 ; curl https://busybox.net/downloads/busybox-${version}.tar.bz2 | tar xjf -
### Configure and compile busybox
>>> cd busybox-${version} 
>>> make defconfig
>>> make LDFLAG=--static -j $(nproc) 2>&1 | tee build.log
>>> make install 2>&1 | tee -a build.log 
>>> ls -1 _install
bin/
linuxrc@
sbin/
usr/
```

Build the initramfs file system

```bash
>>> initfs=/tmp/initramfs && mkdir -p $initfs 
>>> mkdir -pv ${initfs}/{bin,sbin,etc,proc,dev,sys,tmp,root}
>>> sudo cp -va /dev/{null,console,tty} ${initfs}/dev/
### Copy the busybox binaries into the initramfs
>>> cp -avR _install/* $initfs/
>>> fakeroot mknod $initfs/dev/ram0 b 1 0
>>> fakeroot mknod $initfs/dev/console c 5 0
### check the busybox environment
>>> fakeroot fakechroot /usr/sbin/chroot $initfs/ /bin/sh
>>> cat ${initfs}/init
#!/bin/sh

/bin/mount -t proc none /proc
/bin/mount -t sysfs none /sys
/sbin/mdev -s

echo -e "\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n"

exec /bin/sh
>>> chmod +x ${initfs}/init
>>> find $initfs -print0 | cpio --null -ov --format=newc | gzip -9 > /tmp/initrd.gz
```

Test using a virtual machine:

```bash
>>> cmdline='root=/dev/ram0 rootfstype=ramfs init=init debug console=ttyS0'
>>> kvm -nographic -m 2048 -append "$cmdline" -kernel ${KERNEL}/${version}/linux -initrd /tmp/initrd.gz
```

### Systemd

Debian user-space and systemd in an initramfs:

```bash
>>> apt install -y debootstrap systemd-container
>>> export ROOTFS_PATH=/tmp/rootfs
## create the root file-system
>>> debootstrap stretch $ROOTFS_PATH
## configure the root fiel-system
>>> chroot $ROOTFS_PATH
>>> passwd                          # change the root password
>>> ln -s /sbin/init /init          # use systemd as /init
>>> exit
## create an initramfs image from the roofs
>>> ( cd $ROOTFS_PATH ; find . | cpio -ov -H newc | gzip -9 ) > /tmp/initramfs.cpio.gz
## test with a virtual machine
>>> kvm -m 2048 -kernel /boot/vmlinuz-$(uname -r) -initrd /tmp/initramfs.cpio.gz
```

## Trouble Shooting

While testing a new initramfs image in a virtual machine with [KVM](kvm.md)
following error message may indicate not enough memory to uncompress 
the image:

```bash
...
[    0.974160] Unpacking initramfs...
[    1.230752] Initramfs unpacking failed: write error
...
```

Use option `-m <MB>` to increase the available memory.
