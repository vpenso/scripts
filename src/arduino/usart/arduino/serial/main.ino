#include <Arduino.h>

// Uncomment the following definition to enable debug output
//define _DEBUG

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

int sread;

void setup() {
  // Enable Serial port with with defined bit-rate
  Serial.begin(SERIAL_BAUDRATE);
  DEBUG_PRINTLN("Start serial port SEND_RCVE");
  // On-board LED in output mode, and switched off
  pinMode(LED_BUILTIN,OUTPUT);
  digitalWrite(LED_BUILTIN,LOW);
  Serial.println("Awaiting input: ");
}

void loop() {
  // Check if the numbers of available bytes in the
  // serial port read buffer is bigger then zero
  if (Serial.available() > 0 ) {
    // read the next incoming byte
    sread = Serial.read();
    DEBUG_VALUE("Read",sread);
    Serial.print(sread); // base 10
    Serial.print(" (decimal) ");
    Serial.print(sread, HEX);
    Serial.print(" (base 16) ");
    Serial.print(char(sread)); // type cast
    Serial.println(" (char)");
    // logic comparison
    if (sread == '1') {
      digitalWrite(LED_BUILTIN,HIGH);
      Serial.println("On-board LED on");
    }
    if (sread == '0') {
      digitalWrite(LED_BUILTIN,LOW);
      Serial.println("On-board LED off");
    }
  }
}

