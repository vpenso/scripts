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

## Raspberry Pi OS

Download the latest image from:

<https://downloads.raspberrypi.org/>

Raspberry Pi OS Lite minimal image without the X-server window manager.

```bash
# write the image to SD card
unzip -p $archive | sudo dd status=progress bs=4M of=/dev/mmcblk0 conv=fsync
```

Default user `pi` password `raspberry`

# Configuration

```
# find the Pi revision number
grep -i -e ^revision -e ^hardware /proc/cpuinfo
# model information (in later versions)
cat /proc/device-tree/model     
```

### Monitor Resolution

```
tvservice -s         # current resolution
tvservice -m DMT     # list monitor resolution
```

Configure HDMI in `/boot/config.txt`

```bash
# enable DMT mode
hdmi_group=2
# audio over HDMI
hdmi_drive=2
# always start HDMI
hdmi_force_hotplug=1
# resolution 1920x1080/60Hz (1080p)
hdmi_mode=82
```

