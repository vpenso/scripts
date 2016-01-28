
# Boot

## USB

Build from the [ipxe.org](http://ipxe.org) repository

    » apt-get install build-essential genisoimage
    » git clone git://git.ipxe.org/ipxe.git git.ipxe.org
    » cd git.ipxe.org/src/
    » make bin/ipxe.iso
    » make bin/ipxe.usb
    » ls -1 ../bin/ipxe.[iu]* 

Eventually uncomment defines for commands like `nslookup`, `ping` (cf. [ipxe.org/buildcfg](http://ipxe.org/buildcfg))

    config/general.h
    config/console.h

Move images to the `ipxe/` sub-directory.

Run the iPXE image in a virtual machine for development and testing

    » kvm -m 512 ipxe.usb
    » virt-install --ram 2048 --cdrom=ipxe.iso --nodisk --name ipxetest

## Floppy

Prepare an image file (usable as virtual device over IPMI):

    » sudo apt-get install dosfstools
    » /sbin/mkfs.vfat -C "floopy.img" 1440
    » sudo mount -o loop,uid=$UID -t vfat floopy.img mnt/
    » df -h mnt 
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/loop0      1.4M     0  1.4M   0% /srv/projects/boot/mnt

Write iPXE to the floopy disk

    » sudo dd if=ipxe/ipxe.usb of=/dev/loop0
    » sudo umount mnt/
    » cp floopy.img ipxe/ipxe.floopy

## ISO over HTTP

Boot an debian-net-installer live ISO image with the sanboot command from the iPXE prompt

    iPXE> sanboot http://……/debian/iso/debian-7.8.0-amd64-netinst.iso

When the Linux kernel has started up it is no longer able to access the "emulated" CD-ROM iPXE sets up.

## PXELINUX over HTTP

HTTP replaces TFTP as a source to load the Linux kernel and init-file-system. Scaling for mass deployment can be provided by the usual HTTP proxy/cache technologies, enabling more flexible cross network segment configuration also.

[PXELINUX][1] is a light weight Linux kernel specifically configured to support PXE.

Debian supports netbooting with its [netboot.tar.gz][2] archive. Extract this into a HTTP server document-root:

    » ls -1
    config
    debian-installer
    menu
    netboot.tar.gz
    preseed
    pxelinux.0
    pxelinux.cfg
    version.info

Following components are included:

- `pxelinux.0` is the executable launched by the client.
- `pxelinux.cfg/` is a directory containing the configuration
- `debian-installer/` includes the Debian-Installer and the Boot Screen 

_PXELINUX will look for its configuration file using TFTP by default. [Overwrite this behavior][3] by adjusting DHCP options 209 and/or 210._

The following `menu` file contains a very simple iPXE script to launch PXELINUX over HTTP:

    #!ipxe
    imgfree
    set 210:string http://……/debian/installer/wheezy/amd64/
    chain ${210:string}pxelinux.0 ||
    echo Netboot failed
    shell

Load this configuration file from the iPXE prompt:

    iPXE> chain http://……/debian/installer/wheezy/amd64/menu

DHCP option 209 enables to load a custom PXELINUX configuration (relative to the path of option 210):

    #!ipxe
    […]
    set 209:string config/default
    […]




# Usage


Press **CTRL-B** to reach the iPXE command line. 

<kbd>ifstat</kbd> lists the available network interfaces (cf. [ipxe.org/cmd](http://ipxe.org/cmd))

    iPXE> ifstat
    iPXE> dhcp

If possible use the command <kbd>dhcp</kbd> to acquire an IP address. Otherwise use <kbd>config</kbd> to start the interactive configuration tool to adjust IP settings. Afterwards enable the network interface with <kbd>ifopen</kbd>: 

    iPXE> ifopen net0

Eventually use `ping` and/or `nslookup address` to check connectivity.



[1]: http://www.syslinux.org/wiki/index.php/The_Syslinux_Project
[2]: https://www.debian.org/distrib/netinst#netboot
[3]: http://etherboot.org/wiki/httpboot
