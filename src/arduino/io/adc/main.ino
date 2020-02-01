#include <Arduino.h>

// Uncomment the following definition to enable debug output
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
  #define DEBUG_BIN(txt,val)
#endif

#define SERIAL_BAUDRATE 9600

void adc_setup() {
  // Set reference voltage to AVCC (+5V)
  ADMUX |= (1<<REFS0);
  // Set pre-scale to 128 - 125KHz sample rate @ 16MHz
  ADCSRA |= (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
  // Enable ADC
  ADCSRA |= (1<<ADEN);
}

int adc_read(int channel) {
  // select input Channel
  ADMUX |= channel & 0b00000111; // mask low bits 
  // make sure to  right adjust result 
  ADMUX &= ~(1<<ADLAR);
  // start single analog to digital conversions
  ADCSRA |= (1<<ADSC);
  // wait for conversion to complete
  while(!(ADCSRA & (1<<ADIF)));
  // clear ADIF by writing one to it
  ADCSRA |= (1<<ADIF);
  // read the combined data register
  return ADC;
}

int adc_read_byte(int channel) {
  // select input Channel
  ADMUX |= channel & 0b00000111; // mask low bits 
  // left adjust result 
  ADMUX |= (1<<ADLAR);
  // start single analog to digital conversions
  ADCSRA |= (1<<ADSC);
  // wait for conversion to complete
  while(!(ADCSRA & (1<<ADIF)));
  // clear ADIF by writing one to it
  ADCSRA |= (1<<ADIF);
  // read only the high-byte
  return ADCH;
}

void setup() {
  // Enable Serial port with with defined bit-rate
  Serial.begin(SERIAL_BAUDRATE);
}

void loop() {
  
  /* --
     Read an analog signal with the Arduino library function
     -- */

  // read an 10-bit ADC conversion result
  int value = analogRead(A2);
  DEBUG_VALUE("analogRead()",value);
  // convert the result into an 8-bit value
  DEBUG_VALUE("map()",map(value,0,1023,0,255));
  delay(1000);

  /* --
     Read an analog signal using the ADC data registers 
     -- */

  // initialize ADC
  adc_setup();
  // bits for the ADMUX.MUX[3:0] input channel selection
  int channel = 0b00000010; // ADC2
  // read an 8-bit ADC conversion result
  DEBUG_VALUE("adc_read_byte()",adc_read_byte(channel));
  delay(1000);
  // read an 10-bit ADC conversion result
  DEBUG_VALUE("adc_read()",adc_read(channel));
  delay(1000);

}

