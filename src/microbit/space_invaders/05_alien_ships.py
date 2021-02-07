from microbit import *
from random import *

GAME_SPEED = 75
MAX_ROCKETS = 5

class Game:
    
    def __init__(self):
        self.ship_position = 2
        self.rockets = []
        self.alien_ships = []
    
    def player_input(self):
        # ship movement
        acceleration = accelerometer.get_x()
        if acceleration < 100:
            if self.ship_position > 0:
                self.ship_position -= 1
        if acceleration > 100:
            if self.ship_position < 4:
                self.ship_position += 1
        # fire rockets
        if button_a.was_pressed():
            if len(self.rockets) <= MAX_ROCKETS:
                self.rockets.append([self.ship_position,4])
    
    def motion(self):
        rockets = []
        for index in range(len(self.rockets)):
            # if a rocket is still active
            if self.rockets[index][1] > 0:
                # move the rocket
                self.rockets[index][1] -= 1
                rockets.append(self.rockets[index])
        self.rockets = rockets
        
        self.alien_ships.append([randint(0,4),0])
        
        alien_ships = []
        for index in range(len(self.alien_ships)):
            if self.alien_ships[index][1] < 4:
                self.alien_ships[index][1] += 1
                alien_ships.append(self.alien_ships[index])
        self.alien_ships = alien_ships
                
    
    def draw(self):
        display.clear()
        
        for alien in self.alien_ships:
            display.set_pixel(alien[0],alien[1],6)
        
        # draw player rockets
        for rocket in self.rockets:
            display.set_pixel(rocket[0],rocket[1],3)
        
        # draw player ship
        display.set_pixel(self.ship_position, 4, 9)

while True:

    display.show(Image.TARGET)
    # Wait for either button to be pressed.
    while not (button_a.was_pressed() or button_b.was_pressed()):
        sleep(1)

    game = Game() # Create our game object.
    
    while True:
        game.draw()
        game.motion()
        game.player_input()
        sleep(GAME_SPEED)

