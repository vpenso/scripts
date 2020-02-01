#include <Arduino.h>
#include <avr/io.h>
#include <avr/interrupt.h>

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

ISR (TIMER1_OVF_vect)    // Timer1 ISR
{
  // toggle pin
  PORTB ^= (1<<PB0);
  TCNT1 = 63974;   // for 1 sec at 16 MHz
}

void setup() {
  
  Serial.begin(SERIAL_BAUDRATE);

  // set pin D8 as output
  DDRB |= (1<<PB0);

  // TC 1 Control Register A
  TCCR1A = 0x00; // normal mode

  // TC 1 Control Register B, Clock Select Bit Description
  TCCR1B = (1<<CS12) | (0<<CS11) | (1<<CS10);  // Timer mode with 1024 prescaler

  // TC 1 Interrupt Mask Register
  TIMSK1 = (1 << TOIE1) ;   // Overflow Interrupt Enable

  // initialize TC1 counter register 
  TCNT1 = 63974; // for 1 sec at 16 MHz

  sei(); // Enable global interrupts by setting global interrupt enable bit in SREG

}


void loop() { }
