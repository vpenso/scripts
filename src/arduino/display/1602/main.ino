#include <LiquidCrystal.h> // library to control LCDs

const int sec = 1000;

/* Initialize the library with the pins connected to the LCD
 *
 * - Creates a variable of type LiquidCrystal called `lcd`
 * - Uses the register select pin RS and the enable signal pin E 
 * - 4 pins used for data lines D4 up to D7
 */
LiquidCrystal lcd(12, 11, 5,  4,  3,  2 );
//                RS, E,  D4, D5, D6, D7 

void setup() {
  // Configure the LCD screens dimensions (width/height)
  lcd.begin(16,2); // 16 characters by two lines
  // Print text to the screen
  lcd.print("...");
}

void loop() {
  delay(sec);
  // Clear the screen
  lcd.clear();
  // Position the LCD cursor at the 10th column, in the second row
  lcd.setCursor(10,1);
  // Set the display to scroll automatically, by pushing previous 
  // characters one column to the left
  lcd.autoscroll();
  int i;
  // Display the numbers 0 up to 9
  for(i = 0; i < 10; i++) {
    lcd.print(i);
    delay(sec);
  }
}
