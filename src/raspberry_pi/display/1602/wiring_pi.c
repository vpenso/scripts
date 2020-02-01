#include <stdio.h>
#include <wiringPi.h>
#include <lcd.h>

#define LCD_COLS  16
#define LCD_ROWS  2
#define LCD_MODE  4   // use 4 data lines
#define LCD_RS    26
#define LCD_EN    24
#define LCD_D4    22
#define LCD_D5    18
#define LCD_D6    16
#define LCD_D7    12

int main() {
        // Initialise WiringPi
	wiringPiSetup();
        // Initialise the LCD
        int lcd;
        if (lcd = lcdInit (LCD_ROWS, 
                           LCD_COLS, 
                           LCD_MODE, 
                           LCD_RS, 
                           LCD_EN, 
                           LCD_D4, 
                           LCD_D5, 
                           LCD_D6, 
                           LCD_D7, 
                           0, 0, 0, 0)) {
                printf("LCD initialise failed\n");
                return -1;
        }
        lcdClear(lcd);
        //Position cursor on the first line in the first column
        lcdPosition(lcd,0,0);
        //Print the text on the LCD at the current cursor postion
        lcdPuts(lcd, "Hello, world in C...");
}
