---
title: NixOS Introduction
author: Victor Penso
created: 2019/12/20
updated: -
---

# NixOS Introduction

Abstract from "NixOS: A Purely Functional Linux Distribution" [nixpfl]:

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

Most people will be used to imperative programming languages (like C or Java)
where a sequence of statements changes the state of the program. A simple
overwrite of a variable loses a previously stored value. Loops are stateful 
computations that iterate over variables and mutate their values within each 
step, an inherently stateful approach. 

Functional programming is done with expressions or declarations instead of
statements. It treats computation as the evaluation of "pure" functions
**avoiding state and mutable data**. The output of a function depends only on
its input arguments, and will always produce the same output for a given input.
In contrast to the imperative model where a function output not only depends on
the input arguments, but the global program state. Pure functions are
compostable: That is, **self-contained** and stateless (not depending on
external state).

NixOS is an operating system based on the Linux Kernel build with a package
management system implemented in the **Nix expression language**. This language
uses  "pure" functions - expressions - to describe each software package. An
expression includes a **derivation** that describes the package build and its
dependencies. The evaluation of derivations builds packages in a
**deterministic reproducible** way and writes the resulting contents in to Nix
store.  The **Nix store** is an immutable content-addressable directory. Entries
use a hash as name derived from all inputs to a derivation. Hence each package
build for a given software version is uniquely identified.

## Installation

Following example uses Virtual Machine Tools [vmtool] to **install NixOS into a
virtual machine**.  Alternatively select an appropriate method of installation
from the NixOS Manual [nixman], and continue to the next section.

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

**Install NixOS** with `nixos-install` suing the configuration file above:

```bash
nixos-install    # prompts for the root password
# after the installation is finished
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

[nixdep] A Deep Dive into NixOS: From Configuration To Boot  
https://jin.crypt.sg/files/nixos-deep-dive.pdf

[vmtool] Virtual Machine Tools (vm-tools)  
https://github.com/vpenso/vm-tools
