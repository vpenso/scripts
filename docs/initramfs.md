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

### Linux Kernel Support

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

### C Program Initrd

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

### BusyBox Initrd

Download the latest BusyBox from [busybox.net](https://busybox.net/downloads/)

```bash
### Download and extract busybox
>>> version=1.26.2 ; curl https://busybox.net/downloads/busybox-${version}.tar.bz2 | tar xjf -
### Configure and compile busybox
>>> cd busybox-${version} 
>>> make menuconfig
# → Busybox Settings → Build Options → Build BusyBox as a static binary (no shared libs)
>>> make -j 4 2>&1 | tee build.log
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

# Tool Chain

Tools helping build an initramfs image:

* [dracut](http://git.kernel.org/cgit/boot/dracut/dracut.git)
* [initramfs-tools](https://anonscm.debian.org/gitweb/?p=kernel/initramfs-tools.git)
* [mkinitcpio](https://git.archlinux.org/mkinitcpio.git/)
* [mkinitramfs-II](https://github.com/tokiclover/mkinitramfs-ll)

## Initramfs-tools

Modular initramfs generator tool chain maintained by Debian:

<https://tracker.debian.org/pkg/initramfs-tools>

```bash
apt install -y initramfs-tools                       # install package
## manage initramfs images on the local file-system, utilizing mkinitramfs
man update-initramfs                                 # manual page
/etc/initramfs-tools/update-initramfs.conf           # configuration
update-initramfs -u -k $(uname -r)                   # update initramfs of the currently running kernel
```

Low-level tools to generate initramfs images:

```bash
man initramfs-tools                                  # introduction to writing scripts for mkinitramfs
man initramfs.conf                                   # configuration file documentation
/etc/initramfs-tools/initramfs.conf                  # global configuration
ls -1 {/etc,/usr/share}/initramfs-tools/conf*        # hooks overwriting the configuration file
ls -1 {/etc,/usr/share}/initramfs-tools/hooks*       # hooks executed during generation of the initramfs
ls -1 {/etc,/usr/share}/initramfs-tools/modules*     # module configuration
mkinitramfs -o /tmp/initrd.img-$(uname -r)           # create an initramfs image for the currently running kernel
sh -x /usr/sbin/mkinitramfs -o /tmp/initrd.img-$(uname -r) | tee /tmp/mkinitramfs.log
                                                     # debug the image creation
lsinitramfs                                          # list content of an initramfs image
lsinitramfs /boot/initrd.img-$(uname -r)             # ^ of the currently running kernel
```

Live-boot support for the initramfs image:

```bash
apt install -y live-boot live-boot-initramfs-tools
```

## Dracut

Event-driven software to build initramfs images:

<https://dracut.wiki.kernel.org>



```bash
apt install -y dracut dracut-network
dracut --help | grep Version                   # show program version
/etc/dracut.conf                               # configuration files
/etc/dracut.conf.d/*.conf
dracut -fv /tmp/initrd.img                     # create a new initramfs
lsinitrd /tmp/initrd.img                       # inspect an initramfs
```

Enable logging with:

```bash
>>> cat /etc/dracut.conf.d/log.conf
logfile=/var/log/dracut.log
fileloglvl=6
```


### Boot Stages

The bootloader loads the kernel and its initramfs. When the kernel boots it unpacks the initramfs and executes `/init` (installed from `99base/init.sh` module). Init runs following phases:

| Phase  | Hooks                       | Comment                                                                        |
|--------|-----------------------------|--------------------------------------------------------------------------------|
| Setup  | cmdline                     | Source `dracut-lib.sh`, start logging if requested, parse the kernel arguments |
| Udev   | pre-udev, pre-trigger       | Start `udevd`, run `udevadm trigger`, load kernel modules                      |
| Main   | initqueue                   | Wait for devices until `initqueue/finished`                                    |
| Mount  | pre-mount, mount, pre-pivot | Mount root device, check for target /init                                      |
| Switch | cleanup                     | Clean up, stop udev, stop logging. Start target /init                          |

### Modules

Dracut builds the initramfs out of modules:

* Each prefixed with a number which determines the order during the build.
* Lower number modules have higher priority (can't be overwritten by subsequent modules)
* Builtin modules are numbered from 90-99

```bash
man dracut.modules                             # documentation
ls -1 /usr/lib/dracut/modules.d/**/*.sh        # modules with two digit numeric prefix, run in ascending sort order
dracut --list-modules | sort                   # list all available modules
## within the build initramfs
/usr/lib/dracut/hooks/                         # all hooks
```


All module installation information is in the file *`module-setup.sh`* with following functions:

| Function        | Description                                             |
|-----------------|---------------------------------------------------------|
| check()         | Check if module should be included                      |
| depends()       | List other required modules                             |
| cmdline()       | Required kernel arguments                               |
| install()       | Install non-kernel stuff (scripts, binaries, etc)       |
| installkernel() | Install kernel related files (e.g drivers)              |


### Network 

Create a network aware initramfs with the `dracut-network` package:

* The root file-system is located on a network drive, i.e. NFS
* Boot over the network with PXE

Network related command-line arguments:

```bash
rd.driver.post=mlx4_ib,ib_ipoib,ib_umad,rdma_ucm # load additional kernel modules
ip=10.20.2.137::10.20.0.1:255.255.0.0:lxb001.devops.test:ib0:off
nameserver=10.20.1.11 rd.route=10.20.0.0/16:10.20.0.1:ib0
rd.neednet=1                # bring up networking interface without netroot=
rd.retry=80                 # wait until the interfaces becomes ready
```
