
→ [www.kernel.org](https://www.kernel.org/)  
↴ [var/aliases/kernel.sh](../var/aliases/kernel.sh)

```bash
## -- Build a Linux kernel -- ##
apt -y install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev
wget -qO- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.8.11.tar.xz | tar -xvJ
make x86_64_defconfig                                   # x86_64 configuration 
make kvmconfig                                          # enable KVM support
make -j4                                                # compile on multi-core
kernel=$KERNEL/linux-4.8.11-basic
cp -v arch/x86/boot/bzImage $kernel && cp -v .config ${kernel}.config
                                                        # save kernel and its configuration
make modules                                            # compiles modules
make modules_install INSTALL_MOD_PATH=${kernel}.modules # installs kernel modules
## -- Minimal Debian user-space -- ##
sudo debootstrap testing /tmp/rootfs                             # minimal Debian user-space
rootfs=$ROOTFS/debian-testing.img
dd bs=1M seek=4095 count=1 if=/dev/zero of=$rootfs               # crate an disk image file
sudo mkfs.ext4 -F $rootfs                                        # initialize a file-system
sudo mount -v -o loop $rootfs /mnt                               # mount the disk image
sudo cp -a /tmp/rootfs/. /mnt                                    # copy user-space
sudo cp -a ${kernel}.modules/. /mnt                              # copy kernel modules
sudo chroot /mnt /bin/bash -c "sed -i '/^root/ { s/:x:/::/ }' /etc/passwd"
                                                                 # make root passwordless 
sudo umount /mnt     
## -- Boot custom kernel with with a dedicated root file-system -- ##
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic /srv/rootfs/debian-testing.img
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic /srv/rootfs/debian-testing.img -initrd /srv/kernel/linux-4.8.11-basic.initramfs
```

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
dracut --list-modules | sort                   # list all available modules
ls -1 /usr/lib/dracut/modules.d/**/*.sh        # modules with two digit numeric prefix, run in ascending sort order
```






