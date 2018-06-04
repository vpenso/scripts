Enable SSH access in a live-system and login as _root_ if working remote:

```bash
# install aand start an SSH server
pacman -Sy && pacman --noconfirm -S openssh
systemctl start sshd
passwd         # set a root password
```

Prepare the target storage device, and install Archlinux:

```bash
timedatectl set-ntp true                    # sync clock
```

### Installations

Storage:

```bash
ls /sys/firmware/efi/efivars                # check for EFI support
lsblk | grep '^.da*'                    # identify the storage device
### --- MBR partition table --- ###
device=/dev/vda
parted $device mklabel msdos
parted $device mkpart primary ext4 1MiB 100%
mkfs.ext4 ${device}1
mount ${device}1 /mnt
### --- GPT parititon table --- ###
sgdisk --zap-all /dev/vda               # wipe it if required
cgdisk /dev/vda                         # partition the disk device
### 1 100MB EFI partition # Hex code ef00
### 2 250MB Boot partition # Hex code 8300
### 3 100% size partiton # Hex code 8300
mkfs.vfat -F32 /dev/vda1
mkfs.ext2 /dev/vda2
mkfs.ext4 /dev/vda3
### Mount all partitions
mount /dev/vda3 /mnt ; df -h /mnt       
mkdir /mnt/boot && mount /dev/vda2 /mnt/boot
mkdir /mnt/boot/efi && mount /dev/vda1 /mnt/boot/efi
```

Install ArchLinux:

```bash
pacstrap -i /mnt base vim               # install the base system
# generate file-system information
genfstab -pU /mnt >> /mnt/etc/fstab ; cat /mnt/etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> /mnt/etc/fstab
```

### Configuration

```bash
arch-chroot /mnt /bin/bash                        # change root into the target OS tree
## time configuration
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime 
hwclock --systohc --utc
## localization 
echo LANG=en_US.UTF-8 >> /etc/locale.conf && echo LANGUAGE=en_US >> /etc/locale.conf && echo LC_ALL=C >> /etc/locale.conf
## hostname
echo arch > /etc/hostname
cat /etc/hosts
127.0.0.1       arch.devops.test        arch
::1             arch.devops.test        arch
# set the root password
passwd                           
## Enable DHCP 
ip link | grep ^[1-9]            # find the name of the network interface
systemctl enable dhcpcd@ens3.service
## Install OpenSSH server
pacman -S openssh && systemctl enable sshd
```

### Boot

```bash
# add module to the initramfs build
grep ^MODULES /etc/mkinitcpio.conf
MODULES="ext4"
# build the initramfs image
mkinitcpio -p linux
# BIOS
pacman -S grub
grub-install $device
# UEFI
pacman -S grub-efi-x86_64 efibootmgr 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
# generate the Grub configuration
grub-mkconfig -o /boot/grub/grub.cfg 
```

Exit, reboot. Login as root and start customization:

## Desktop

    » pacman -S xorg-server xorg-xinit xorg-server-utils mesa xf86-video-vesa gnome
    » systemctl enable gdm.service






