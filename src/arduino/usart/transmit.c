#include <avr/io.h>

#define F_CPU 16000000UL
#include <util/delay.h>

unsigned char data = 'h';

int main(void) {

  /*
   * Configure USART
   * */
  UCSR0C |= (1<<UPM01) | (0<<UPM00); // enable, even parity
  UCSR0C |= (0<<UCSZ02) | (1<<UCSZ01) | (1<<UCSZ00); // 8-bit characters
  UBRR0L = 103; // baud rate
  UCSR0B |= (1<<TXEN0); // enable transmission

  while(1) {
    while ( !( UCSR0A & (1<<UDRE0)) ); // wait for empty transmit buffer
    UDR0 = data; //write data to the transmit buffer
    _delay_ms(50);
  }

}
