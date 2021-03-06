Download the latest version of the **Arduino IDE** into `~Downloads`:

<https://www.arduino.cc/en/Main/Software>

```bash
mkdir -p ~/arduino && cd ~/arduino
# extract the downloaded archive & rename the directory
version=1.8.11
tar -xvf ~/Downloads/arduino-$version-linux64.tar.xz && mv arduino-$version $version
# run the installer
sudo ~/arduino/$version/install.sh
# add ARDUINO_HOME to your shell environment, e.g.:
test -d ~/.zshrc.d && \
      echo "export ARDUINO_HOME=~/arduino/$version\nexport PATH=\$ARDUINO_HOME:\$PATH" \
      > ~/.zshrc.d/arduino
```

**Connect an Arduino the computers USB port!**

Find the device used for the communication over USB and the user group allowed to access it

```bash
# show serial USB devices
find /dev -name 'ttyACM*' -o -name 'ttyUSB*' | xargs stat --printf "%n %G\n"
# or run
lsusb-serial
```

Add your user account permanently to the required group (e.g. `dialout`) to use serial ports:

```bash
# debian
sudo gpasswd -a $USER dialout ; newgrp dialout
# arch
sudo gpasswd -a $USER uucp ; newgrp uucp
```

**Re-login to make the change active!**

### Usage

The Arduino **integrated development environment** (IDE) includes a code editor, and provides simple one-click mechanisms to compile and upload programs to an Arduino board.

* Start the Arduino IDE, and connect the Arduino board to USB.
* Select the right Arduino board in the **Tools** ➝ **Board** menu, e.g. "Arduino/Genuino Uno"
* Select the connection port in the **Tools** ➝ **Port** menu, e.g. `/dev/ttyACM0`.
* Select the **Blink** program in the **File** ➝ **Examples** ➝ **01.Basics** menu.
* Press the **Upload** button (arrow right) beneath the menu, or press **Ctrl-u**.

Configure the **Sketchbook location** in the **File** ➝ **Preferences** menu to the source directory `src/`.

* Arduino program files (extension `.ino`) require an enclosing sketch folder.
* The main-program file needs to be called like the sketch folder.
* Load sketches from **File** ➝ **Sketchbook**

## Commands

Shell functions defined in ↴ [var/aliases/avr.sh](../var/aliases/avr.sh) (cf. [docs/flash.md](../docs/flash.md)):

* `AVR_DEVICE` - USB connection port to the Arduino/AVR device (default `/dev/ttyACM0`)
* `AVR_BAUDRATE` - Serial communication speed (default 115200 for Arduino Uno)

```bash
# build and upload a AVR program to the Arduino Uno
>>> avr-upload $AVR_HOME/src/blink.c
# same for the Arduino Nano
>>> AVR_DEVICE=/dev/ttyUSB0 AVR_BAUDRATE=57600 avr-upload $AVR_HOME/src/io/gpio/blink.c
```

Shell functions defined in ↴ [var/aliases/arduino.sh](../var/aliases/arduino.sh)

* [arduino](https://github.com/arduino/Arduino/blob/master/build/shared/manpage.adoc) command man-page

```bash
# build and upload an Arduino sketch
>>> arduino-upload $AVR_HOME/src/io/gpio/blink/blink.ino
# build an Arduino sketch
>>> /bin/rm -rf $AVR_HOME/build/* ; arduino-builder $AVR_HOME/src/io/gpio/blink/blink.ino
>>> ls -1 $AVR_HOME/build
blink.ino.eep
blink.ino.elf*
blink.ino.hex
blink.ino.with_bootloader.hex
build.options.json
core/
includes.cache
libraries/
preproc/
sketch/
```

A **serial monitor** displays the data transmitted via serial communication

* The Arduino IDE has a build in monitor (start with **CTRL-SHIFT-m**)
* The Arduino Makefile support the command `make monitor`

```bash
# use GNU Screen for serial communication
screen /dev/ttyACM0 9600
# or minicom
minicom -D /dev/ttyACM0 -b 9600 
```

# Makefile

Install the latest [Arduino-Makefile](https://github.com/sudar/Arduino-Makefile) from GitHub:

```bash
# path to the installation
ARDMK_DIR=~/projects/arduino-makefile
# clone the Git repository
git clone https://github.com/sudar/Arduino-Makefile.git $ARDMK_DIR
# add ARDMK_DIR to your shell environment, e.g.:
echo "export ARDMK_DIR=$ARDMK_DIR\nexport PATH=\$ARDMK_DIR/bin:\$PATH" > ~/.zshrc.d/21_ardmk
```

Following an example `Makefile` using `ARDUINO_HOME` as path to the Arduino software:

```bash
>>> grep -e ARD -e AVR $AVR_HOME/src/io/gpio/blink/Makefile 
ARDUINO_DIR   = $(ARDUINO_HOME)
AVR_TOOLS_DIR = $(ARDUINO_HOME)/hardware/tools/avr/
AVRDUDE      = $(AVR_TOOLS_DIR)/bin/avrdude
AVRDUDE_CONF = $(AVR_TOOLS_DIR)/etc/avrdude.conf
```

Use the `make` command to compile the source code, and `make upload` to flash the binary to the Arduino:

```bash
>>> cd $AVR_HOME/src/io/gpio/blink
# build
>>> make && ls build-uno/*.hex
build-uno/led_blink.hex
# upload to the MCU
>>> make upload
# remove build artifacts
>>> make clean
```

Adjust the `BOARD_TAG` and `MONITOR_PORT` according to the Arduino used.  For example to compile and upload to and Arduino Nano:

```bash
## Configure the Makefile for the Arduino Nano
>>> grep -e ^BOARD -e PORT Makefile
BOARD_TAG        = nano328
MONITOR_PORT     = /dev/ttyUSB0
```


