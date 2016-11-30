

Minimal Debian user-space:

```bash
>>> ostree=/tmp/ostree osimg=/tmp/os.img ; mkdir $ostree
>>> sudo debootstrap <suite> $ostree                                 # minimal Debian user-space
>>> dd if=/dev/zero of=$osimg bs=1M seek=4095 count=1                # crate an disk image file
>>> sudo mkfs.ext4 -F $osimg                                         # initialize a file-system
>>> sudo mount -o loop $osimg /mnt                                   # mount the disk image
>>> sudo cp -a $ostree/. /mnt                                        # copy user-space
## -- Modify the user-space image with chroot -- ##
>>> sudo chroot /mnt /bin/bash                                       # in order to modify the disk image
chroot> sed -i '/^root/ { s/:x:/::/ }' /etc/passwd                   # make root passwordless 
...
chroot> exit
>>> sudo umount /mnt
```

Build Linux from [kernel.org](https://www.kernel.org/) with a minimal configuration for a virtual machine:

```bash
apt -y install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev 
wget -qO- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.8.11.tar.xz | tar -xvJ
make x86_64_defconfig                                   # x86_64 configuration 
make kvmconfig                                          # enable KVM support
make -j4                                                # compile on multi-core
cp arch/x86/boot/bzImage /srv/kernel/linux-4.8.11-basic
cp .config /srv/kernel/linux-4.8.11-basic.config
```

↴ [var/aliases/kvm.sh](../var/aliases/kvm.sh)

## Dracut

Loaded into memory during Linux boot and used as intermediate root file-system (aka. early user space):

* Prepares device drivers required to mount the **final root file-system** (rootfs) if is loaded:
  - ...by addressing a label or UUID
  - ...from the network (NFS, iSCSI, NBD)
  - ...from a logical volume LVM, software (ATA)RAID `dmraid`, device mapper multi-pathing
  - ...from an encrypted source `dm-crypt`
  - ...live system on `squashfs` or `iso9660`
* RAM-based file-system, cf. [ramfs, rootfs and initramfs](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)
* Bundled into a single compressed cpio archive
* Mounted by the kernel to `/` if present, before executing `/init` 

[Dracut](https://dracut.wiki.kernel.org) is an infrastructure to build an initramfs, cf. `dracut`, [dracut.git](http://git.kernel.org/cgit/boot/dracut/dracut.git)

* Uses `udev` to create device nodes
* Functionality provided by generator modules, cf. `dracut.modules`
* Configuration passed by kernel parameters, cf. `dracut.cmdline`
* Init with [systemd](systemd.md), cf. `dracut.bootup` 

```bash
dracut --help | grep Version                   # show program version
/etc/dracut.conf                               # configuration file
ls -1 /usr/lib/dracut/modules.d/**/*.sh        # modules with two digit numeric prefix, run in ascending sort order
```






