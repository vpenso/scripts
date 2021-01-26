# Installation

Options for pre-build operating systems (OS) images:

[rpios] Raspberry Pi OS  
<https://www.raspberrypi.org/software>  

[rpidb] Debian Raspberry Pi images  
<https://raspi.debian.net>

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

### Raspberry Pi OS

Download the latest image from:

<https://downloads.raspberrypi.org/>

Raspberry Pi OS Lite minimal image without the X-server window manager.

```bash
# write the image to SD card
unzip -p $archive \
        | sudo dd status=progress conv=fsync bs=4M of=/dev/mmcblkX
```

Default user `pi` password `raspberry`


# BuildRoot

[melgh] Mastering Embedded Linux, George Hilliard  
<https://www.thirtythreeforty.net/posts/2019/08/mastering-embedded-linux-part-1-concepts/>

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
git clone http://git.buildroot.net/buildroot
```

```shell
# generate the configuration for the target hardware
make raspberrypi0w_defconfig
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
board/	        Files and scripts to support each target board
configs/	Build configurations such as raspberrypi0w_defconfig
package/	Package definitions
output/host/	Build tools that run on the workstation
output/target/	Target output directory where target binaries are staged
output/images/	Filesystem images and the final firmware image are emitted here
```
