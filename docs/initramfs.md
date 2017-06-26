# Initramfs

Loaded into memory during Linux boot and used as intermediate root file-system (aka. early user space):

* RAM-based file-system, cf. [ramfs, rootfs and initramfs](https://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt)
* Prepares device drivers required to mount the **final root file-system** (rootfs) if is loaded:
  - ...by addressing a label or UUID
  - ...from the network (NFS, iSCSI, NBD)
  - ...from a logical volume LVM, software (ATA)RAID `dmraid`, device mapper multi-pathing
  - ...from an encrypted source `dm-crypt`
  - ...live system on `squashfs` or `iso9660`
* Provides a minimalistic rescue shell
* Mounted by the kernel to `/` if present, before executing `/init` main init process (PID 1)

→ [Custom Ininitramfs](https://wiki.gentoo.org/wiki/Custom_Initramfs)  
→ [Initramfs Tutorial](http://nairobi-embedded.org/initramfs_tutorial.html)

## Dracut

[Dracut](https://dracut.wiki.kernel.org) is an infrastructure to build an initramfs, cf. `dracut`, [dracut.git](http://git.kernel.org/cgit/boot/dracut/dracut.git)



```bash
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

Configuration passed by kernel parameters, cf. `dracut.cmdline`

```bash
rd.info rd.shell rd.debug                      # enable debugging
console=tty0 console=ttyS1,115200n8            # serial console 
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
```

Create a network aware initramfs with the `dracut-network` package:

* The root file-system is located on a network drive, i.e. NFS
* Boot over the network with PXE

All module installation information is in the file *`module-setup.sh`* with following functions:

| Function        | Description                                             |
|-----------------|---------------------------------------------------------|
| check()         | Check if module should be included                      |
| depends()       | List other required modules                             |
| cmdline()       | Required kernel arguments                               |
| install()       | Install non-kernel stuff (scripts, binaries, etc)       |
| installkernel() | Install kernel related files (e.g drivers)              |



### Unpack/repack

Xz compressed image:

```bash
>>> file initrd.img
initrd.img: XZ compressed data
>>> xz -dc < initrd.img | cpio --quiet -i --make-directories
...
>>> find . 2>/dev/null | cpio --quiet -c -o | xz -9 --format=lzma >"new_initrd.img"
```


