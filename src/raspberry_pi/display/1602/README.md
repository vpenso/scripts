## Wires

Provide Power to the LCD module:

LCD   | Power | Description
------|-------|-------------
VDD   | 5V    | board power
VSS   | 0V    | board ground
RW    | 0V    | **read/write select**, 0V for write only
A     | 5V    | backlight power
K     | 0V    | backlight ground

Connect the potentiometer (trimmer) to the LCD module:

LCD   | Input            | Description
------|------------------|-----------------
V0    | POT (middle pin) | **control the contrast** of the LCD

Connect the LCD to the Pi in **4 bit mode**:

LCD   | BMC    | BOARD | Description
------|--------|-------|-------------------
RS    | GPIO07 | 26    | **register select**, `HIGH` store in data register, `LOW` store in instruction register
E     | GPIO08 | 24    | **write enable**, write data to register when ready
D4    | GPIO25 | 22    | 4 **data lines**...
D5    | GPIO24 | 18    | ...send characters and instructions 4 bits at a time...
D6    | GPIO23 | 16    | ...4 high bits are sent followed by 4 low bits... 
D7    | GPIO18 | 12    | ...complete the 8 bit character or instruction

## Code

### CircuitPython 

Read the AdaFruit [adafrt] example.

```bash
# install required Python packages
apt-get install python3 python3-pip
pip3 install adafruit-blinka adafruit-circuitpython-charlcd
```

Find a basic example in [circuit_python.py](circuit_python.py)

### C

Read the CircuitBasics [circb] example for using WiringPi

```bash
# install the required C library
apt install wiringpi
gpio readall                  # list all GPIO pin values
# compile the example
gcc -lwiringPi -lwiringPiDev -o wiring_pi wiring_pi.c
```

Find a basic example in [wiring_pi.c](wiring_pi.c)

## Reference

[adafrt] Drive a 16x2 LCD with the Raspberry Pi  
https://learn.adafruit.com/drive-a-16x2-lcd-directly-with-a-raspberry-pi/overview

[circb] How to Setup an LCD on the Raspberry Pi and Program it With C  
https://www.circuitbasics.com/raspberry-pi-lcd-set-up-and-programming-in-c-with-wiringpi

[mbtech] Drive an LCD 16x2 display with Raspberry Pi  
https://www.mbtechworks.com/projects/drive-an-lcd-16x2-display-with-raspberry-pi.html

[rpiblog] Interfacing 16x2 LCD with Raspberry Pi using GPIO & Python  
http://www.rpiblog.com/2012/11/interfacing-16x2-lcd-with-raspberry-pi.html
