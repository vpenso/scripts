from microbit import *

# ship position on the x-axis
ship_position = 2
# list of fired missiles
missiles = []

def wait_for_button():
    # Wait for either button to be pressed.
    while not (button_a.was_pressed() or button_b.was_pressed()):
        sleep(1)

def user_input():
    
    global ship_position
    acceleration = accelerometer.get_x()
    if acceleration < -100:
        if ship_position > 0:
            ship_position -= 1
    if acceleration > 100:
        if ship_position < 4:
            ship_position += 1

    global missiles
    if button_a.was_pressed():
        missiles.append((ship_position,3))

def draw():
    display.clear()
    
    # draw ship
    display.set_pixel(ship_position,4,9)
    
    # draw missiles
    for missile in missiles:
        display.set_pixel(missile[0],missile[1],3)

while True:

    display.show(Image.TARGET)
    wait_for_button()
    while True:
        draw()
        user_input()
        sleep(50)
    display.show(Image.ANGRY)
    sleep(1000)

