# Raspberry Pi 4 Bootloader

SPI-attached EEPROM (4MBits/512KB)

* Contains code to boot up the system 
* [LED warning flash codes][02], [Boot Diagnostics][03]

[01]: https://github.com/raspberrypi/rpi-eeprom/blob/master/firmware/release-notes.md
[02]: https://www.raspberrypi.org/documentation/configuration/led_blink_warnings.md
[03]: https://www.raspberrypi.org/documentation/hardware/raspberrypi/boot_diagnostics.md


Check the bootloader version:

```bash
# check the version
vcgencmd bootloader_version
# update
sudo rpi-eeprom-update
# configuration 
/etc/default/rpi-eeprom-update
```

* Adjust `BOOT_ORDER` configuration for the priority of different boot modes
 - Cf. [Bootloader configuration](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md)
 - `0xf14` try USB followed by SD

```
sudo raspi-config # 6 Advanced Options -- A6 Boot Order
# view the current EEPROM configuration
sudo rpi-eeprom-config
# edit it and apply the updates to latest EEPROM release
sudo -E rpi-eeprom-config --edit
```

Copy the SD card to USB/SATA device

```bash
sudo dd bs=4M if=/dev/mmcblk0 of=/dev/sda
                |           |    |      |
                |           |    `------`------ USB/SATA device
                `-----------`------------------ SD device
```
