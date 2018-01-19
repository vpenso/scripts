## Initramfs-tools

Modular initramfs generator tool chain maintained by Debian:

<https://tracker.debian.org/pkg/initramfs-tools>

* **Hook** scripts are used to create an initramfs image.
* **Boot** scripts are included into the initramfs image and executed during boot.

```bash
apt install -y initramfs-tools                       # install package
## manage initramfs images on the local file-system, utilizing mkinitramfs
man update-initramfs                                 # manual page
/etc/initramfs-tools/update-initramfs.conf           # configuration
update-initramfs -u -k $(uname -r)                   # update initramfs of the currently running kernel
```

Low-level tools to generate initramfs images:

```bash
man initramfs-tools                                  # introduction to writing scripts for mkinitramfs
man initramfs.conf                                   # configuration file documentation
/etc/initramfs-tools/initramfs.conf                  # global configuration
ls -1 {/etc,/usr/share}/initramfs-tools/conf.d*      # hooks overwriting the configuration file
ls -1 {/etc,/usr/share}/initramfs-tools/hooks*       # hooks executed during generation of the initramfs
ls -1 {/etc,/usr/share}/initramfs-tools/modules*     # module configuration
/usr/share/initramfs-tools/hook-functions            # help functions use within hooks
mkinitramfs -o /tmp/initramfs.img                    # create an initramfs image for the currently running kernel
sh -x /usr/sbin/mkinitramfs -o /tmp/initramfs.img |& tee /tmp/mkinitramfs.log
                                                     # debug the image creation
lsinitramfs                                          # list content of an initramfs image
lsinitramfs /boot/initrd.img-$(uname -r)             # ^ of the currently running kernel
unmkinitramfs <image> <path>                         # extract the content of an initramfs
```

## Debug

Use following to build a new initramfs and to debug it with a virtual machine:

* The `debug` argument writes a log-file to `/run/initramfs/initramfs.debug`
* Use `break=` to spawn a shell at a chosen run-time (top, modules, premount, mount, mountroot, bottom, init)
* The shell is basically bash with busybox...

```bash
# build the image
>>> mkinitramfs -o /tmp/initramfs.img
# start kernel & initramfs with debug flags
>>> kvm -nographic -kernel /boot/vmlinuz-$(uname -r) -initrd /tmp/initramfs.img -append 'console=ttyS0 debug break=top' 
...
(initramfs) poweroff -f
...
```

Examine an initramfs image by extracting it into a temporary directory:

```bash
>>> cd `mktemp -d` && gzip -dc /tmp/initramfs.img | cpio -ivd
# the first program called by the Linux kernel
>>> cat init
...
```

## Hooks

Executed during image creation to add and configure files. 

Following scripting header is used as a skeleton:

* `PREREQ` should contain a list of dependency hooks
* Read `/usr/share/initramfs-tools/hook-functions` for a list of predefined helper-functions. 

Following examples loads Infiniband drivers:

```bash
>>> cat /etc/initramfs-tools/hooks/infiniband
#!/bin/sh
PREREQ=""
prereqs()
{
     echo "$PREREQ"
}

case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac

. /usr/share/initramfs-tools/hook-functions

mkdir -p ${DESTDIR}/etc/modules-load.d

# make sure the infiniband modules get loaded
cat << EOF > ${DESTDIR}/etc/modules-load.d/infiniband.conf
mlx4_core
mlx4_ib
ib_umad
ib_ipoib
rdma_ucm
EOF

for module in $(cat ${DESTDIR}/etc/modules-load.d/infiniband.conf); do
        manual_add_modules ${module}
done
## make the hook executable
>>> chmod +x /etc/initramfs-tools/hooks/infiniband
## check if required file are in the initramfs image
>>> lsinitramfs /tmp/initramfs.img  | grep infiniband
```

# Live-Boot

The `live-boot` package contains a hook for the initramfs-tools that configure 
a live system during the boot process (early userspace):

* Activated if `boot=live` was used as a kernel parameter
* At boot time it will look for a (read-only) medium containing a "/live" directory where a root filesystems (often a compressed filesystem image like squashfs) is stored. If found, it will create a writable environment, using aufs, to boot the system from. 

```bash
apt install -y live-boot live-boot-docs live-config
man live-boot                            # overview documentation
```

## Debug

HTTP server hosting the files for network booting over PXE:

```bash
# install the Apache web-server
>>> apt install -y apache2
>>> rm /var/www/html/index.html
```

```bash
# use initramfs-tools on Debian
>>> apt install -y live-boot live-boot-initramfs-tools
# publish the Linux kernel
>>> cp /boot/vmlinuz-$(uname -r) /var/www/html/vmlinuz
# create an initramfs image
>>> mkinitramfs -o /var/www/html/initramfs.img
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
kernel vmlinuz initrd=initramfs.img boot=live components toram fetch=http://10.1.1.28/filesystem.squashfs
initrd initramfs.img
boot
```

Start a virtual machine with the iPXE bootloader

```
>>> wget http://boot.ipxe.org/ipxe.iso
# start a virtual machine with the iPXE bootloader
>>> kvm -m 2048 ipxe.iso
## Ctrl+B to get to the iPXE prompt
iPXE> dhcp
```
iPXE> chain http://10.1.1.28/menu

