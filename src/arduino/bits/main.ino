#include <avr/io.h>
#include <Arduino.h>

#define _DEBUG

#ifdef _DEBUG
  #define DEBUG_PRINT(txt) Serial.print(txt);
  #define DEBUG_PRINTLN(txt) Serial.println(txt);
  #define DEBUG_VALUE(txt,val) Serial.print(txt); Serial.print(": "); Serial.println(val)
  #define DEBUG_BIN(txt,val) Serial.print(txt); Serial.print(": 0b"); Serial.println(val,BIN);
#else
  #define DEBUG_PRINT(txt)
  #define DEBUG_PRINTLN(txt)
  #define DEBUG_VALUE(txt,val)
#endif

#define SERIAL_BAUDRATE 9600

#define bit_set(byte,bit)             (byte |= _BV(bit))
#define bit_clear(byte,bit)           (byte &= ~_BV(bit))
#define bit_toggle(byte,bit)          (byte ^= _BV(bit))

void setup() {

  Serial.begin(SERIAL_BAUDRATE);

  bit_set(DDRB,PB4);
  DEBUG_BIN("DDRB",DDRB);
}

void loop() {
  bit_set(PORTB,PB4); // binary one, aka. LED on
  delay(100);
  bit_toggle(PORTB,PB4);
  delay(100);
}

