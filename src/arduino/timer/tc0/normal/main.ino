#include <Arduino.h>
#include <avr/io.h>

#define _DEBUG

#ifdef _DEBUG
  #define DEBUG_PRINT(txt) Serial.print(txt);
  #define DEBUG_PRINTLN(txt) Serial.println(txt);
  #define DEBUG_VALUE(txt,val) Serial.print(txt); Serial.print(": "); Serial.println(val);
  #define DEBUG_BIN(txt,val) Serial.print(txt); Serial.print(": 0b"); Serial.println(val,BIN);
#else
  #define DEBUG_PRINT(txt)
  #define DEBUG_PRINTLN(txt)
  #define DEBUG_VALUE(txt,val)
  #define DEBUG_BIN(txt,val)
#endif

#define SERIAL_BAUDRATE 9600

/*

Run the TC0 (timer/counter0) in normal mode, 8-bit (2^8=256 step)

       | Description               | Value
-------|---------------------------|----------------------
FCPU   | CPU frequency             | 16.000.000Hz (16MHz)
CS     | Clock prescaler           | 1024
FTC    | Timer frequency FCPU/CS   | 15.625 Hz
TTC    | Clock ticks 1/FTC         | 0,000064s
OVTC   | Timer overflow 256*TTC    | 0,016384s (16ms)

*/

int count = 0;

void setup() {
  Serial.begin(SERIAL_BAUDRATE);
  // set pin D8 as output
  DDRB |= (1<<PB0);
  // 1024 pre-scalar in normal mode
  TCCR0B = (1<<CS02) | (0<<CS01) | (1<<CS00);
}

void loop() {
  // while the overflow flag is logic zero, wait
  while((TIFR0 & (1<<TOV0)) == 0);
  // timer overflow has happened
  count++;
  // clear the overflow flag by writing logic one
  TIFR0 |= (1<<TOV0);
  // execute every have a second - 1/OVTC =~31
  if ((count % 31) == 0) 
  {
    // toggle pin D8
    PORTB ^= (1<<PB0);
    // milli-seconds since since power on
    DEBUG_PRINTLN(millis());
  }
}
