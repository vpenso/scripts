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

from gpiozero import LED,PWMLED,Button
from time import sleep
from signal import pause

# GPIO 25 (BCM, physical pin 22)
pin = 25

# represent an LED on a given pin
led = LED(pin) 

print(led.pin, 'on')
led.on()
sleep(1)

print(led.pin, 'off')
led.off()
sleep(1)

for i in (range(5)):
    print(led.pin, 'toggle', i)
    led.toggle()
    sleep(1)

if led.is_lit:
    print(led.pin, 'off')
    led.off()

# release the pin
led.close()
# represents a light emitting diode (LED) with variable brightness
led = PWMLED(pin)

for i in (0.25,0.5,1,0.5,0.25):
    print(led.pin, 'value', i)
    led.value = i
    sleep(1)

# bakc to non PWM mode
led.close() ; led = LED(pin)

# GPIO 9 (BCM, physical pin 21)
pin = 9
# represents a simple push button
button = Button(pin)

print('Press the button...')
# Pause the script until the device is activated
button.wait_for_press()
print(button.pin, 'pressed')

def led_toggle():
    print(button.pin, 'pressed')
    print(led.pin, 'toggle')
    led.toggle()

button.when_pressed = led_toggle

print('Terminated manually by pressing Ctrl+C')
# sleep until a signal is received; the appropriate handler will then be called
pause()
