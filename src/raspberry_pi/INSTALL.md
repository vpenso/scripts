# Installation


[rpios] Raspberry Pi OS  
<https://www.raspberrypi.org/software>  

Download the latest image from:

<https://downloads.raspberrypi.org/>

Use [etcher](https://etcher.io/) to create bootable SD/USB devices.

```bash
# write the image to SD card
unzip -p $archive \
        | sudo dd status=progress conv=fsync bs=4M of=/dev/mmcblkX
```

Default user `pi` password `raspberry`

## Alternatives

Options for pre-build operating systems (OS) images:

[rpidb] Debian Raspberry Pi images  
<https://raspi.debian.net>  
<https://raspi.debian.net/defaults-and-settings> 

* Default login `root` with empty password
* Customize in `/boot/firmware/sysconf.txt`
* Ethernet port runs DHCP by default

[rpiub] Ubuntu Raspberry Pi Images  
<https://ubuntu.com/download/raspberry-pi>

[rpifd] Fedora Raspberry Pi 4 Image  
<http://fedoraproject.org/wiki/Raspberry_Pi>

[rpimj] Manjaro Raspberry Pi 4 Image  
<https://www.manjaro.org/downloads/arm/raspberry-pi-4/arm8-raspberry-pi-4-xfce/>

Build your own images with:

[bldrt] BuildRoot Embedded Linux Build System  
<https://buildroot.org>

[yocto] Yocto Embedded Linux Distribution  
<https://www.yoctoproject.org>



# BuildRoot

[bldrm] The Buildroot User Manual  
<https://buildroot.org/downloads/manual/manual.html>

[melgh] Mastering Embedded Linux, George Hilliard  
<https://www.thirtythreeforty.net/posts/2019/08/mastering-embedded-linux-part-1-concepts/>

Use a virtual machine as build environment:

```shell
# install depenencies
sudo apt install -y \
        bc \
        build-essential \
        cpio \
        file \
        git \
        libncurses5-dev \
        qemu-system-x86 \
        rsync \
        screen \
        unzip \
        wget \
# get the BuildRoot source code
git clone git://git.busybox.net/buildroot
# or
git clone https://github.com/buildroot/buildroot.git
```

```shell
# list available boards
make list-defconfigs | grep rasp
# generate the configuration for the target hardware
make raspberrypi0w_defconfig
# customization
make menuconfig    # search with `/`
# build
make
# write the SD card image
sudo dd bs=1M status=progress conv=fsync \
        if=output/images/sdcard.img of=/dev/mmcblkX
```

For debugging/testing it may be more convenient to use a:

```shell
# virtual machine configuration
make qemu_x86_64_defconfig
...
# launch the root-filesystem in a virtual machine
output/host/bin/qemu-system-x86_64 -M pc \
        -kernel output/images/bzImage \
        -drive file=output/images/rootfs.ext2,if=virtio,format=raw \
        -append "rootwait root=/dev/vda" \
        -net nic,model=virtio -net user
```



Directory structure:

```shell
host/           Built for the host, sysroot of the target toolchain
board/	        Files and scripts to support each target board
configs/	Build configurations such as raspberrypi0w_defconfig
package/	Package definitions
output/host/	Build tools that run on the workstation
output/target/	Target output directory where target binaries are staged
output/images/	Filesystem images and the final firmware image are emitted here
```
