## Configuration

```
# find the Pi revision number
grep -i -e ^revision -e ^hardware /proc/cpuinfo
# model information (in later versions)
cat /proc/device-tree/model     
```

Installation OS images:

* [Raspbian](https://www.raspberrypi.org/downloads/raspbian/)
  - user/password pi/raspberry
* [Fedora](https://fedoraproject.org/wiki/Architectures/ARM/Raspberry_Pi)
* Debian [Raspberry Pi Images](https://wiki.debian.org/RaspberryPiImages)

```bash
# Raspbian
unzip -p $archive | sudo dd status=progress bs=4M of=/dev/sdb conv=fsync
# Fedora
xzcat $image | sudo dd status=progress bs=4M of=/dev/sdb conv=fsync
```

### Monitor Resolution

```
tvservice -s         # current resolution
tvservice -m DMT     # list monitor resolution
```

Configure HDMI in `/boot/config.txt`

```
# enable DMT mode
hdmi_group=2
# audio over HDMI
hdmi_drive=2
# always start HDMI
hdmi_force_hotplug=1
# resolution 1920x1080/60Hz (1080p)
hdmi_mode=82

### GPIO

General purpose input-output (GPIO) connector:

* Uses Broadcom BCM2835 [bcmp], 40-pin GPIO header [pinout]
* Supports 5v, 3.3v, PWM, I2C, SPI, UART (serial)

```bash
sudo apt install -y python3-gpiozero
sudo adduser $USER gpio     # allow a user to access GPIO pins (requiers a re-login/newgrp)
pinout                      # show the pinout
```

### I2C/SPI

```bash
# install required packages
apt install -y python-smbus i2c-tools
# install kernel support
raspi-config
# select: - Interface Options, I2C or SPI Enable... - from the menu (reboot required)
```
```bash
i2cdetect -l                 # list the <i2cbus> number
i2cdetect -y <i2cbus>        # scan the I2C bus for devices    
ls -l /dev/i2c*              # check for the I2C device
ls -l /dev/spidev*           # check for the SPI device
```

Enable a second SPI port with `dtoverlay=spi1-3cs` in `/boot/config.txt` (reboot required)

## Python

```bash
# install all packages
apt install -y python3 python3-pip python3-gpiozero
pip3 install adafruit-blinka
```

GPIOZero [gzero] uses only Broadcom (BCM) pin numbering (opposed to physical (BOARD) numbering)

