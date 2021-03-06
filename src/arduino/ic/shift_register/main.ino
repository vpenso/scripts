/*
Control a group of 8x LEDs using a 74HC595 Shift Register

  - Pin 1-7,15 output to LEDs + 220ohm resistors
  - Pin 8  == GND connect to ground
  - Pin 10 == MR, Master Reclear, connect to 5V
  - Pin 13 == OE, Output enable, connect to ground
  - Pin 16 == VCC connect to 5V
*/

const int msec = 3000;
// Output pins connected to the 74HC595 shift register
const int dPin = 4; // goes to pin 14 == DS, Serial data input 
const int lPin = 5; // goes to pin 12 == ST_CP, Storage register clock pin (latch pin)
const int cPin = 6; // goes to pin 11 == SH_CP, Shift register clock pin


// Represents the state of the shift register chip 
// Pins 1-7,15 == Q0-Q7, Output Pins
byte leds = 0;

// Print bit representation of a byte
void serialPrintByte(byte b) {
  byte i;
  // loop bit shift
  for (byte i = 0; i < 8; i++) {
    Serial.print(b >> i & 1, BIN);
  }
  Serial.println("");
}

void txRegisterState(byte state) {
  // Signal the register to read from the data pin
  digitalWrite(lPin, LOW);
  Serial.println("Ground latch pin while transmitting data");
  // Use the data pin to send a byte to the register bit-by-bit
  //   - Right most LSB (Least Significant Bit)
  shiftOut(dPin, cPin, LSBFIRST, state);
  // Signal the register to set all its output pins
  digitalWrite(lPin, HIGH);
  Serial.print("LEDs bit state: ");
  serialPrintByte(leds);
  Serial.println("Signal end of transmission");
}


void setup() {
  Serial.begin(9600);
  pinMode(dPin, OUTPUT);
  pinMode(lPin,OUTPUT);
  pinMode(cPin,OUTPUT);
}

void loop() {
  txRegisterState(leds);
  delay(msec);
  for (int i = 0; i < 8; i++) {
    bitSet(leds,i);
    txRegisterState(leds);
    delay(msec);
  }
  leds = 0;
}
