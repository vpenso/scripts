
## PXE

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

## iPXE

Press **CTRL-B** to reach the iPXE command line. 

→ [PXE Command Reference](http://ipxe.org/cmd)

```bash
help                                   # list evailable commands
<command> --help                       # show command help text
config                                 # start the interactive configuration tool
ifstat                                 # lists the available network interfaces
dhcp                                   # acquire an IP address
ifopen net0                            # enable the network interface, e.g. net0
show net0/ip                           # network-interface IP address
route                                  # show routing table
chain tftp://<ip>/<path>/pxelinux.0    # load PXE configuration from ip/path
sanboot http://.../img.iso             # boot ISO image over HTTP
```

**USB Image**

Build from the [ipxe.org](http://ipxe.org) repository

```bash
apt-get install build-essential genisoimage
git clone git://git.ipxe.org/ipxe.git git.ipxe.org
cd git.ipxe.org/src/
make bin/ipxe.iso
make bin/ipxe.usb
ls -1 ../bin/ipxe.[iu]* 
```

Eventually uncomment defines for commands like `nslookup`, `ping` (cf. [ipxe.org/buildcfg](http://ipxe.org/buildcfg))

```bash
config/general.h
config/console.h
```

Move images to the `ipxe/` sub-directory.

Run the iPXE image in a virtual machine for development and testing

```bash
kvm -m 512 ipxe.usb
virt-install --ram 2048 --cdrom=ipxe.iso --nodisk --name ipxetest
```

**Floppy Disks**

Prepare an image file (usable as virtual device over IPMI):

```bash
sudo apt-get install dosfstools
/sbin/mkfs.vfat -C "floopy.img" 1440                 # create a floppy image
sudo mount -o loop,uid=$UID -t vfat floopy.img mnt/  # mount the floopy image 
df -h mnt | grep loop                                # find loop device name
sudo dd if=ipxe/ipxe.usb of=/dev/loop0               # write iPXE to floopy
sudo umount mnt/
cp floopy.img ipxe/ipxe.floopy
```



[1]: http://www.syslinux.org/wiki/index.php/The_Syslinux_Project
[2]: https://www.debian.org/distrib/netinst#netboot
[3]: http://etherboot.org/wiki/httpboot
