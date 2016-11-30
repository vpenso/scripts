

Minimal Debian user-space:

```bash
>>> ostree=/tmp/jessie osimg=/tmp/os.img
>>> mkdir $ostree && debootstrap jessie $ostree                      # minimal Debian user-space
>>> dd if=/dev/zero of=$osimg bs=1M seek=4095 count=1                # crate an disk image file
>>> sudo mkfs.ext4 -F $osimg                                         # initialize a file-system
>>> sudo mount -o loop $osimg /mnt                                   # mount the disk image
>>> sudo cp -a $ostree/. /mnt                                        # copy user-space
>>> sudo chroot /mnt /bin/bash                                       # in order to modify the disk image
## -- Modify the user-space image with chroot -- ##
chroot> sed -i '/^root/ { s/:x:/::/ }' /etc/passwd                   # make root passwordless 
chroot> cat /etc/network/interfaces.d/eth0                           # enable networking
auto eth0
iface eth0 inet dhcp
chroot> exit
>>> sudo umount /mnt
```

Build Linux from [kernel.org](https://www.kernel.org/) with a minimal configuration for a virtual machine:

```bash
>>> apt -y install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev 
>>> wget -qO- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.8.11.tar.xz | tar -xvJ
                                                            # get the Linux kernel source code
>>> make x86_64_defconfig && make kvmconfig                 # x86_64 confgiuration with KVM support
>>> make -jX                                                # compile on multi-core
>>> kvm -kernel arch/x86/boot/bzImage -drive file=$osimg,if=virtio -nographic -append "console=ttyS0 root=/dev/vda rw"
                                                            # boot the kernel
        -netdev user,id=net0 -device virtio-net-pci,netdev=net0
                                                            # enable networking
```
[kernel parameters](https://www.kernel.org/doc/Documentation/kernel-parameters.txt)

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

Internal flow of execution:

1. Basic Setup (hooks: cmdline, pre-udev)
2. Start Udev (hook: pre-trigger)
3. Trigger Udev – **Initqueue**
4. Wait for job or Udev settled – **Initqueue-{settled,finished}**
5. Found root device (hooks: pre-mount, mount, pre-pivot)
6. Cleanup, switch root

```bash
dracut --help | grep Version                   # show program version
/etc/dracut.conf                               # configuration file
ls -1 /usr/lib/dracut/modules.d/**/*.sh        # modules with two digit numeric prefix, run in ascending sort order
```






