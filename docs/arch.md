Start a virtual machine (with UEFI support):

```bash
## Install Archlinux with an ISO image downloaded from https://www.archlinux.org/download/
virt-install --name arch --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
             --boot uefi --cdrom /tmp/archlinux-2017.07.01-x86_64.iso
```


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
>>> cgdisk /dev/vda                         # partition the disk device
1 100MB EFI partition # Hex code ef00
2 250MB Boot partition # Hex code 8300
3 100% size partiton # Hex code 8300
## Create the file-systems in all partitions
>>> mkfs.vfat -F32 /dev/vda1
>>> mkfs.ext2 /dev/vda2
>>> mkfs.ext4 /dev/vda3
### Mount all partitions
>>> mount /dev/vda3 /mnt ; df -h /mnt       
>>> mkdir /mnt/boot && mount /dev/vda2 /mnt/boot
>>> mkdir /mnt/boot/efi && mount /dev/vda1 /mnt/boot/efi
>>> df | grep /mnt
/dev/vda3       40668628  49180  38523888   1% /mnt
/dev/vda2         247919   2063    233056   1% /mnt/boot
/dev/vda1         100808   5807     95002   6% /mnt/boot/efi
>>> pacstrap -i /mnt base vim               # install the base system
## Regsiter the fils-system
>>> genfstab -pU /mnt >> /mnt/etc/fstab ; cat /mnt/etc/fstab
>>> echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /mnt/etc/fstab
```
Configuration

```bash
>>> arch-chroot /mnt /bin/bash                        # change root into the target OS tree
## time configuration
>>> ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime 
>>> hwclock --systohc --utc
## localization 
>>> echo LANG=en_US.UTF-8 >> /etc/locale.conf && echo LANGUAGE=en_US >> /etc/locale.conf && echo LC_ALL=C >> /etc/locale.conf
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
>>> grep ^MODULES /etc/mkinitcpio.conf
MODULES="ext4"
>>> mkinitcpio -p linux
>>> pacman -S grub-efi-x86_64 efibootmgr 
>>> grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
```

Exit, reboot. Login as root and start customization:

    » pacman -S zsh zsh-completions zsh-syntax-highlighting grml-zsh-config
    » chsh -s $(which zsh)
    » echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> /etc/zsh/zprofile

## Desktop

    » pacman -S xorg-server xorg-xinit xorg-server-utils mesa xf86-video-vesa gnome
    » systemctl enable gdm.service






