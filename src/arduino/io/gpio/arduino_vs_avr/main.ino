#include <Arduino.h>

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

#define D3 3 // label pin D3

void setup() {
  
  Serial.begin(SERIAL_BAUDRATE);
  
  // Set pin D3 (PD3) as output
  pinMode(D3,OUTPUT);
  // set pins D10 (PB2) and D12 (PB4) as output
  // all other pins including D8 (PB1) as input
  DDRB = 0b0010100;
  
  // set pin D3 high (1)
  digitalWrite(D3,HIGH);
  // set pins D10 (PB2) and D12 (PB4) high (1)
  PORTB = 0b0010100;

}

void loop() {
  
  // print the value of D8
  DEBUG_VALUE("D8",digitalRead(8));
  // print the values of pins at port B
  DEBUG_BIN("PINB", PINB);
  
  // read the value of D8
  int D8 = 0;
  D8 = PINB & 0x01; // 0b00000001 in HEX
  if (D8 == 1) {
    
    // set pin D3 low (0)
    digitalWrite(D3,LOW);
    // set only pin D12 (PB4) on port B low 
    PORTB &= ~(1<<PB4);
    
  } else {
    
    // set all pins on port D low 
    // except of pin D3 high (1)
    PORTD = 0b00001000;
    // set only pin D12 high (1)
    PORTB |= 1<<PB4;
    
  }
  
  // print the state of the port B register
  DEBUG_BIN("PORTB", PORTB);
  delay(100);

}
