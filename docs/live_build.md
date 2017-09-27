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

A **live systems** boots from a removable medium (CD, USB, or SD card) or the network:

* It does not require a local installation, since it auto-configures at run-time
* Requires following components:
  - Linux **kernel image**
  - Initial **ramdisk image**
  - **System image** providing the root file-system
  - **Bootloader**

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
# a basic iPXE configuration file
>>> cat binar/live/menu
#!ipxe
kernel vmlinuz initrd=initrd.img boot=live components fetch=http://<ip-address>:8000/filesystem.squashfs
initrd initrd.img
boot
# download the iPXE bootloader
>>> wget http://boot.ipxe.org/ipxe.iso
# start a virtual machine with the iPXE bootloader
>>> kvm -m 2048 ipxe.iso
## Ctrl+B to get to the iPXE prompt
iPXE> dhcp
iPXE> chain http://${YOUR_BOOT_URL}
```



# Live Build

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

## Live Configuration


```bash
# create a root file-system
>>> sudo debootstrap stretch /tmp/rootfs
# access the root file-system
>>> sudo chroot rootfs
# start the root file-system in a container
>>> sudo systemd-nspawn -b -D rootfs/
# install live boot components
>>> apt install live-boot live-config live-config-systemd
# create a SquashFS
>>> sudo mksquashfs rootfs boot/filesystem.squashfs
```

```bash
man live-config                           # run-time configuration 
config/includes.chroot/lib/live/config/   # include live-config with live-build
```



