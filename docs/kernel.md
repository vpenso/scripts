
→ [www.kernel.org](https://www.kernel.org/)  
↴ [var/aliases/kernel.sh](../var/aliases/kernel.sh)

Cf. [bootstrap](bootstrap.md) to create a rootfs

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
## -- Boot custom kernel with with a dedicated root file-system -- ##
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic $rootfs
kernel-boot-rootfs /srv/kernel/linux-4.8.11-basic $rootfs -initrd /srv/kernel/linux-4.8.11-basic.initramfs
```

Kernel instrumentation [BBC](https://github.com/iovisor/bcc)

## Dracut

[Dracut](https://dracut.wiki.kernel.org) is an infrastructure to build an initramfs, cf. `dracut`, [dracut.git](http://git.kernel.org/cgit/boot/dracut/dracut.git)

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

Steps during the boot:

* The bootloader loads the kernel and its initramfs
* The kernel boots and mounts the initramfs
* Kernel runs the init ramfs:
  - Basic setup (cmdline, pre-udev)
  - Start udev (pre-trigger)
  - Trigger udev (initqueue)
  - Wait for jobs or udev settled (initqueue settled, finished)
  - Found root device (pre-mount, mount, pre-pivot)
  - Cleanup and switch to the new init (cleanup)
* Systemd will in charge of the rest of the boot process

### Usage

* Uses `udev` to create device nodes
* Functionality provided by generator modules, cf. `dracut.modules`
* Init with [systemd](systemd.md), cf. `dracut.bootup` 

```bash
dracut --help | grep Version                   # show program version
/etc/dracut.conf                               # configuration files
/etc/dracut.conf.d/*.conf
dracut --list-modules | sort                   # list all available modules
ls -1 /usr/lib/dracut/modules.d/**/*.sh        # modules with two digit numeric prefix, run in ascending sort order
dracut -fv /tmp/initrd.img                     # create a new initramfs
lsinitrd /tmp/initrd.img                       # inspect an initramfs
```

Enable logging with:

```bash
>>> cat /etc/dracut.conf.d/log.conf
logfile=/var/log/dracut.log
fileloglvl=6
```

Configuration passed by kernel parameters, cf. `dracut.cmdline`

```bash
rd.info rd.shell rd.debug                      # enable debugging
console=tty0 console=ttyS1,115200n8            # serial console 
```

Unpack/repack an image file:

```bash
>>> file initrd.img
initrd.img: XZ compressed data
>>> xz -dc < initrd.img | cpio --quiet -i --make-directories
...
>>> find . 2>/dev/null | cpio --quiet -c -o | xz -9 --format=lzma >"new_initrd.img"
```

