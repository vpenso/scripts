#!/usr/bin/env python3
#
# Let an LED blink (on and off repeatedly)
# ========================================
#
# Connect the cathode (short leg, flat side) of the LED
# to a ground pin; connect the anode (longer leg) to a 
# limiting resistor; connect the other side of the 
# limiting resistor to a GPIO pin (the limiting resistor 
# can be placed either side of the LED)
#
# Connect one side of the button to a ground pin, and the 
# other to any GPIO pin.
#
# Uses the Adafruit-Blinka library
#
#     https://pypi.org/project/Adafruit-Blinka/

from time import sleep 
import board
import digitalio

led = digitalio.DigitalInOut(board.D25)
led.direction = digitalio.Direction.OUTPUT
 
while True:
    led.value = True
    sleep(1)
    led.value = False
    sleep(1)
