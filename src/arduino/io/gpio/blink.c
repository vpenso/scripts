
/* Include name and addresses of I/O ports
 *
 * */
#include <avr/io.h>

int main(void) {
  long i;
  DDRB = 1<<5; // PB5/D13 is an output
  while(1) {
    PORTB = 1<<5; // binary one, aka. LED on
    for(i = 0; i < 100000; i++); // sleep
    PORTB = 0<<5;
    for(i = 0; i < 100000; i++); // sleep
  }
}
