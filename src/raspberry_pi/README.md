## Configuration

```
# find the Pi revision number
grep -i -e ^revision -e ^hardware /proc/cpuinfo
# model information (in later versions)
cat /proc/device-tree/model     
```

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

## References


[adabli] Adafruit-Blinka, CircuitPython APIs for CPython on Linux and MicroPython  
https://pypi.org/project/Adafruit-Blinka

[bcmp] Broadcom BCM2835 ARM Peripherals  
https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2835/BCM2835-ARM-Peripherals.pdf

[cirpy] CircuitPython on Linux and Raspberry Pi  
https://learn.adafruit.com/circuitpython-on-raspberrypi-linux

[gzero] GPIOZero interface to GPIO devices with Raspberry Pi  
https://gpiozero.readthedocs.io/en/stable/

[pinout] GPIO Pinout guide for the Raspberry Pi  
https://pinout.xyz/

[raspi] Raspberry Pi Hardware Documentation  
https://www.raspberrypi.org/documentation/hardware/raspberrypi/

[rpiio] RPi GPIO Code Samples  
https://elinux.org/RPi_GPIO_Code_Samples

[wirpi] Wiring Pi C GPIO Interface library for the Raspberry Pi  
http://wiringpi.com/
