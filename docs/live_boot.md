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
# move the files to the HTTP server document root
>>> cp binary/live/{vmlinuz,initrd.img,filesystem.squashfs} $HTTP_ROOT
# example iPXE configuration
>>> cat $HTTP_ROOT/menu
#!ipxe
kernel vmlinuz initrd=initrd.img boot=live components fetch=http://<ip-address>/filesystem.squashfs
initrd initrd.img
boot
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
config/bootstrap                         # bootstrap configuration
chroot/                                  # directory containing the root file-system
```

Create the live OS root file-system:

```bash
lb chroot
config/chroot                            # chroot configuration
config/package-lists/*.chroot            # package list to install in chroot
chroot.files                             # list of file in the chroot
chroot.packages.install                  # installed packages
```

## Run-Time Configuration

```bash
man live-config                           # run-time configuration 
```
