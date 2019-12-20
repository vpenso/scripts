---
title: NixOS Introduction
author: Victor Penso
create: 2019/12/20
---

## NixOS Introduction

Abstract from NixOS: A Purely Functional Linux Distribution [nixpfl]:

> Existing package and system configuration management tools suffer from an
> imperative model, where system administration actions such as package upgrades
> or changes to system configuration files are stateful: they destructively
> update the state of the system. This leads to many problems, such as the
> inability to roll back changes easily, to deploy multiple versions of a
> package side-by-side, to reproduce a configuration deterministically on
> another machine, or to reliably upgrade a system.  In this article we show
> that we can overcome these problems by moving to a **purely functional system
> configuration model**. This means that all static parts of a system (such as
> software packages, configuration files and system startup scripts) are built
> by pure functions and are **immutable**, stored in a way analogous to a heap
> in a purely functional language. We have implemented this model in NixOS, a
> non-trivial Linux distribution that uses the Nix package manager to build the
> entire system configuration from a modular, purely functional specification

### Installation

Following example uses Virtual Machine Tools [vmtool] to **install NixOS into a
virtual machine**. You should make yourself familiar with this tools chain to
follow the installation described below. Alternatively select an appropriate
method of installation from the NixOS Manual [nixman], and continue to the next
section.

```bash
os=nixos
mkdir -p $VM_IMAGE_PATH/$os && cd $VM_IMAGE_PATH/$os
# download the latest ISO image [nixdwn]
wget -O ${os}.iso \
        https://releases.nixos.org/nixos/19.09/nixos-19.09.1590.d85e435b7bd/nixos-minimal-19.09.1590.d85e435b7bd-x86_64-linux.iso
# boot a virtual machine instance for installation
virt-install --ram 2048 --os-type linux --virt-type kvm --network bridge=nbr0 \
             --disk path=disk.img,size=40,format=qcow2,sparse=true,bus=virtio \
             --name $os --cdrom ${os}.iso
```

Once the virtual machine instance has booted create partition for `/` (root):

```bash
sudo su  # work as root
# prepare a partiton
parted /dev/vda -- mklabel msdos
parted /dev/vda -- mkpart primary 1MiB 100%
# initialize the file system
mkfs.ext4 -L nixos /dev/vda1
# mount the file system for installation
mount /dev/disk/by-label/nixos /mnt
```

**Generate a NixOS configuration template** with ` nixos-generate-config`:

```bash
nixos-generate-config --root /mnt    # path to the root partition
```

**Adjust the configuration** in `/mnt/etc/nixos/configuration.nix` [nixopt]:

```
# specify on which disk the GRUB boot loader is to be installed
boot.loader.grub.device = "/dev/vda";
# enable login via OpenSSH
services.openssh.enable = true;
# packages to install
environment.systemPackages = with pkgs; [
   wget vim
];
# add a devops user and grant root priviliges via Sudo
users.users.devops = {
  isNormalUser = true;
  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
};
```


Install the system based using the configuration file above.

```bash
nixos-install    # prompts for the root password
reboot
```

## Reference

[nixdwn] NixOS CD/DVD Installer Images  
https://nixos.org/nixos/download.html

[nixman] NixOS Manual, Chapter 2. Installing NixOS  
https://nixos.org/nixos/manual/index.html#sec-installation

[nixopt] NixOS Manual, Appendix A. Configuration Options  
https://nixos.org/nixos/manual/options.html

[nixpfl] NixOS: A Purely Functional Linux Distribution  
https://nixos.org/~eelco/pubs/nixos-jfp-final.pdf

[vmtool] Virtual Machine Tools (vm-tools)  
https://github.com/vpenso/vm-tools
