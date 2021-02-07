from microbit import *

GAME_SPEED = 75

class Game:
    
    def __init__(self):
        self.ship_position = 2
    
    def player_input(self):
            acceleration = accelerometer.get_x()
            if acceleration < 100:
                if self.ship_position > 0:
                    self.ship_position -= 1
            if acceleration > 100:
                if self.ship_position < 4:
                    self.ship_position += 1
    
    def draw(self):
        display.clear()
        
        display.set_pixel(self.ship_position, 4, 9)

while True:

    display.show(Image.TARGET)
    # Wait for either button to be pressed.
    while not (button_a.was_pressed() or button_b.was_pressed()):
        sleep(1)

    game = Game() # Create our game object.
    
    while True:
        game.player_input()
        game.draw()
        sleep(GAME_SPEED)

