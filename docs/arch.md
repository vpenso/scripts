
<https://www.archlinux.org/>

Enable SSH access in a live-system and login as _root_ if working remote:

```bash
pacman -Sy       
pacman -S openssh
systemctl start sshd.service
passwd
```

Select a local block device with `lsblk` to installation of the base system. Wipe an existing partition table with `sgdisk` if required.

```bash
lsblk | grep '^.da*' 
sgdisk --zap-all /dev/vda
cgdisk /dev/vda
parted -l /dev/vda
mkfs.ext4 /dev/vda1
mount /dev/vda1 /mnt ; df -h /mnt
```

Interactive partitioning with `cgdisk` to create a _root_ partition at least. Verify the result with `parted`.

Install the base system with `pacstrap`, and generate `/etc/fstab` on the target file-system.

```bash
pacstrap -i /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab ; cat /mnt/etc/fstab
```

Configuration

```bash
>>> arch-chroot /mnt /bin/bash                        # change root into the target OS tree
## time configuration
>>> ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime 
>>> hwclock --systohc --utc
## localization 
>>> vi /etc/locale.gen               # uncomment "en_US.UTF-8 UTF-8"
>>> grep ^en_US /etc/locale.gen
en_US.UTF-8 UTF-8
>>> echo LANG=en_US.UTF-8 > /etc/locale.conf
>>> locale-gen
## hostname
» echo arch > /etc/hostname
» cat /etc/hosts
127.0.0.1       arch.devops.test        arch
::1             arch.devops.test        arch
>>> passwd                           # set the root password
## Enable DHCP 
>>> ip link | grep ^[1-9]            # find the name of the network interface
>>> systemctl enable dhcpcd@ens3.service
## Install OpenSSH server
>>> pacman -S openssh
>>> systemctl enable sshd
```


Install the bootloader and MBR boot code. Configure the boot menu:

```bash
>>> mkinitcpio -p linux
>>> pacman -S gptfdisk syslinux
>>> syslinux-install_update -iam
Syslinux BIOS install successful
Attribute Legacy Bios Bootable Set - /dev/vda1
Installed MBR (/mnt/usr/lib/syslinux/bios/gptmbr.bin) to /dev/vda
## Adjust the boot menu
>>> grep -C 2 /dev/vda /boot/syslinux/syslinux.cfg 
MENU LABEL Arch Linux
LINUX ../vmlinuz-linux
APPEND root=/dev/vda1 rw
INITRD ../initramfs-linux.img
--
MENU LABEL Arch Linux Fallback
LINUX ../vmlinuz-linux
APPEND root=/dev/vda1 rw
INITRD ../initramfs-linux-fallback.img
```

Exit, reboot. Login as root and start customization:

    » pacman -S zsh zsh-completions zsh-syntax-highlighting grml-zsh-config
    » chsh -s $(which zsh)
    » echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zprofile

## Desktop

    » pacman -S xorg-server xorg-xinit xorg-server-utils mesa xf86-video-vesa gnome
    » systemctl enable gdm.service






