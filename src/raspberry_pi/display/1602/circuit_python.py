#!/usr/bin/env python3
#
# Drive an 16x2 LCD module with Adafruit CircuitPython 
#
# Python packages required:
# - adafruit-blinka
# - adafruit-circuitpython-charlcd

import board
import digitalio
from adafruit_character_lcd.character_lcd import Character_LCD_Mono

lcd_cols = 16
lcd_rows = 2
lcd_rs   = digitalio.DigitalInOut(board.D7)
lcd_en   = digitalio.DigitalInOut(board.D8)
lcd_d4   = digitalio.DigitalInOut(board.D25)
lcd_d5   = digitalio.DigitalInOut(board.D24)
lcd_d6   = digitalio.DigitalInOut(board.D23)
lcd_d7   = digitalio.DigitalInOut(board.D18)

lcd = Character_LCD_Mono(lcd_rs, lcd_en, lcd_d4, lcd_d5, lcd_d6, lcd_d7, lcd_cols, lcd_rows)

lcd.clear()
lcd.message = 'Hello World...'
