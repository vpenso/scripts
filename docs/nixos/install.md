
Install a VM image to be used with [vm-tools](https://github.com/vpenso/vm-tools)

https://nixos.org/nixos/download.html

```bash
os=nixos
iso=nixos.iso
mkdir -p $VM_IMAGE_PATH/$os && cd $VM_IMAGE_PATH/$os
wget -O $iso \
        https://releases.nixos.org/nixos/19.09/nixos-19.09.1590.d85e435b7bd/nixos-minimal-19.09.1590.d85e435b7bd-x86_64-linux.iso
virt-install --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
             --name $os --cdrom $iso
```

Prepare the installation storage:

```bash
sudo su
parted /dev/vda -- mklabel msdos
parted /dev/vda -- mkpart primary 1MiB 100%
mkfs.ext4 -L nixos /dev/vda1
mount /dev/disk/by-label/nixos /mnt
```

[Configuration](https://nixos.org/nixos/manual/index.html#sec-configuration-syntax)

```bash
nixos-generate-config --root /mnt
# adjust the configuration...
nixos-install
```
```nix
boot.loader.grub.device = "/dev/vda";
services.openssh.enable = true;
environment.systemPackages = with pkgs; [
   wget vim
];
users.users.devops = {
  isNormalUser = true;
  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
};
```
```bash
reboot
