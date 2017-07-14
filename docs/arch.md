
<https://www.archlinux.org/>

Enable SSH access in a live-system and login as _root_ if working remote:

```bash
## Install OpenSSH, and start the server
>>> pacman -Sy && pacman --noconfirm -S openssh
>>> systemctl start sshd
>>> passwd                                  # set a root password
```

Prepare the target storage device, and install Archlinux:

```bash
>>> lsblk | grep '^.da*'                    # identify the storage device
>>> sgdisk --zap-all /dev/vda               # wipe it if required
## Create a partion for /
>>> parted /dev/vda mklabel gpt mkpart root ext4 1MiB 100%
>>> parted -l /dev/vda
>>> mkfs.ext4 /dev/vda1                     # create a file-system
>>> mount /dev/vda1 /mnt ; df -h /mnt       # mount the new file-system
>>> pacstrap -i /mnt base                   # install the base system
## Regsiter the fils-system
>>> genfstab -U -p /mnt >> /mnt/etc/fstab ; cat /mnt/etc/fstab
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
>>> echo arch > /etc/hostname
>>> cat /etc/hosts
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
>>> pacman --noconfirm -S grub
>>> grub-install /dev/vda
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






