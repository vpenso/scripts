from microbit import *

def wait_for_button():
    # Wait for either button to be pressed.
    while not (button_a.was_pressed() or button_b.was_pressed()):
        sleep(1)

while True:

    display.show(Image.TARGET)
    wait_for_button()
    
    display.show(Image.ANGRY)
    sleep(1000)
