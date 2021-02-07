from microbit import *

def wait_for_button():
    # Wait for either button to be pressed.
    while not (button_a.was_pressed() or button_b.was_pressed()):
        sleep(1)

# ship position on the x-axis
ship_position = 2

def draw():
    display.clear()
    display.set_pixel(ship_position,4,9)

while True:

    display.show(Image.TARGET)
    wait_for_button()
    while True:
        draw()
    display.show(Image.ANGRY)
    sleep(1000)

