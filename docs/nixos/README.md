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

_Before we dive deeper into the technical details of NixOS and Nix Packages lets
install a virtual machine to enable investigation on a practical example._

### Installation

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

```bash
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

## Architecture

Nearly all Linux distributions overwrite old versions of software packages
with each subsequent update. This includes both static and dynamic dependencies.
Packages are installed into a common Unix style directory hierarchy by
copying package artifacts over multiple directories like `/etc/`, `/bin`,
`/var/` or `/lib` among others. Generally keeping multiple (old) versions of a
single package is not intended, but is sometimes realised using workarounds.
In order to avoid dependency management issues due to changes in new software,
distributions typically make huge incremental steps updating all packages at
once (accompanied by major testing efforts and release management). Some
distributions follow a so called "rolling release" approach where packages get
continuously updated following the upstream software developers as close as
possible. These distributions sometimes suffer from unintended "side effects"
due to the difficulties in keeping all dependencies managed without breaking.

Following is a list of properties common to most Linux distributions:

1. Updates overwrite packages (only on version at a time).
2. Updates are destructive (imperative model) including non-obvious cascading 
   side effects.
3. Rollback to previous package versions is difficult (sometimes impossible).
4. Updates are non-atomic, and can break the system if interrupted.

All the above limitations basically make it **very hard to maintain a
deterministic state of the entire system**. NixOS addresses the issues described
above by not following the common imperative (stateful) model of software
package management.


Following is a list of Nix packages and NixOS properties:

1. **Multiple versions** of a package (including all dependencies) can be
   installed.
2. **Multiple variations** (in build dependencies) of the same package version
   can be installed.
3. Packages will never be overwritten, hence **atomic updates** and **rollback**
   are supported.





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
