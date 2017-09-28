# Linux Live Boot

A **live systems** boots from a removable medium (CD, USB, or SD card) or the network:

* It does not require a local installation, since it auto-configures at run-time
* Requires following components:
  - `vmlinuz` Linux kernel image. cf [kernel.md](kernel.md).
  - `initramfs.img` early user-space, cf. [initramfs.md](initramfs.md).
  - `rootfs.img` target root file-system, cf. [roofs.md](rootfs.md).
  - **Bootloader**, e.g. PXE network boot, cf. [pxe.md](../net/pxe.md).

## Network Boot

HTTP server hosting the files for network booting over PXE: 

```bash
# install the Apache web-server
>>> apt install -y apache2
>>> rm /var/www/html/index.html
```

Start a virtual machine with the iPXE bootloader

```bash
>>> wget http://boot.ipxe.org/ipxe.iso
# start a virtual machine with the iPXE bootloader
>>> kvm -m 2048 ipxe.iso
## Ctrl+B to get to the iPXE prompt
iPXE> dhcp
iPXE> chain http://10.1.1.28/menu
```

### Initramfs-Tools

```bash
# use initramfs-tools on Debian
>>> apt install -y live-boot live-boot-initramfs-tools
>>> update-initramfs -u -k $(uname -r) ## (optional)
# publish the image on the webserver
>>> cp /boot/initrd.img-$(uname -r) /var/www/html/initrd.img
# publish the Linux kernel
>>> cp /boot/vmlinuz-$(uname -r) /var/www/html/vmlinuz
# create a rootfs
>>> apt install -y debootstrap systemd-container squashfs-tools
>>> debootstrap stretch /tmp/rootfs
# access the root file-system
>>> chroot /tmp/rootfs
## ...set the root password ...
# start the root file-system in a container
>>> systemd-nspawn -b -D /tmp/rootfs/
## ... customize ...
# create a SquashFS
>>> mksquashfs /tmp/rootfs /var/www/html/filesystem.squashfs
# iPXE kernel command line
>>> cat /var/www/html/menu
#!ipxe
kernel vmlinuz initrd=initrd.img boot=live components toram fetch=http://10.1.1.28/filesystem.squashfs
initrd initrd.img
boot
```

### Dracut


Live booting with Dracut involves following modules:

* **livenet**e - Parses the `root=live:<URL>` kernel argument, and call the dmsquash-live module after the rootfs image download.
* **dmsquash-live**  - Mounts the rootfs. 

The rootfs image requires a pre-defined nested structure of directories:

<https://fedoraproject.org/wiki/LiveOS_image>  
<https://rwmj.wordpress.com/tag/squashfs/>

```bash
# install Dracut on Debian
>>> apt install -y dracut dracut-network
# disable hostonly mode
>>> cat /etc/dracut.conf.d/10-debian.conf
do_prelink=no
hostonly=no
# include live boot support into initramfs
>>> dracut -f -a livenet /var/www/html/initramfs.img
# iPXE kernel command line for
>>> cat /var/www/html/menu
#!ipxe
kernel vmlinuz initrd=initramfs.img root=live:http://10.1.1.29/filesystem.squashfs
initrd initramfs.img
boot
```


# Live Build

Developer information:

<https://debian-live.alioth.debian.org/>

```bash
>>> apt install -y live-boot live-build
## create a skeletal configuration
>>> lb config
## build a default hybrid ISO image 
>>> sudo lb build 2>&1 | tee build.log
## test the ISO with a virtual machine
>>> kvm -m 2048 -cdrom live-image-amd64.hybrid.iso
```

The source code is available at:

<https://anonscm.debian.org/git/debian-live/>


## Network Boot

iPXE booting over the network from an HTTP server:

```bash
# files required for booting over the network
>>> ls -1 binary/live                            
filesystem.packages
filesystem.packages-remove
filesystem.size
filesystem.squashfs
initrd.img
initrd.img-4.9.0-3-amd64
vmlinuz
vmlinuz-4.9.0-3-amd64
# star a basic web-server
>>> cd binary/live && python3 -m http.server
# ... OR move the files to the HTTP server document root
```

## Commands

High-level command:

```bash
lb build                     # execute the entire build process
lb config                    # executes the configuration
lb clean                     # clean up previous build except for the cache
lb clean --purge             # remove everything including package cache
```

VCS with Git:

```bash
>>> cat .gitignore 
.build
binary/
cache/
chroot*
live-*
```

## Configuration

Configuration of the live-build process

```bash
man lb_config                     # command reference
lb config                         # executes the configuration process
config/                           # configuration directory
cp /usr/share/doc/live-build/examples/auto/* auto/
auto/config                       # lb config wrapper function
```

Example auto-configuration file:

```bash
#!/bin/sh

set -e

lb config noauto \
        --distribution stretch \
        --archive-areas "main contrib non-free" \
        --apt-indices false \
        --apt-recommends false \
        --debian-installer false \
        --initsystem systemd \
        "${@}"
```

## Root File-System

Create a basic Debian root file-system:

```bash
lb bootstrap                             # debootstrap the roo file-system
lb config --mirror-bootstrap <repo>      # configure the package mirror used 
chroot/                                  # directory containing the root file-system
config/bootstrap                         # bootstrap configuration
config/includes.chroot                   # add or replace files in the chroot/
```

Create the live OS root file-system:

```bash
lb chroot
config/chroot                            # chroot configuration
config/package-lists/*.chroot            # package list to install in chroot
chroot.files                             # list of file in the chroot
chroot.packages.install                  # installed packages
```

## Live Config

```bash
man live-config                           # run-time configuration 
config/includes.chroot/lib/live/config/   # include live-config with live-build
```



