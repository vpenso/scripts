from microbit import *

class Game:
    
    def __init__(self):
        self.ship_position = 2
    
    def draw(self):
        display.clear()
        
        display.set_pixel(self.ship_position, 4, 9)
        
game = Game() # Create our game object.

while True:

    game.draw()
