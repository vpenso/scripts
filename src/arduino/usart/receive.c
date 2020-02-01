
#include <avr/io.h>

/*
 * Configure USART
 * */
void usart_init()
{
    UCSR0C |= (1<<UPM01) | (0<<UPM00); // enable, even parity
    UCSR0C |= (0<<UCSZ02) | (1<<UCSZ01) | (1<<UCSZ00); // 8-bit characters
    UBRR0L = 103; // 9600bps@16MHz
    UCSR0B |= (1<<RXEN0) | (1<<TXEN0); // enables the USART transmitter/receiver
}

/*
 * Transmit a character via USART
 * */
void usart_tx_char(char c)
{
    // wait for empty transmit buffer
    while ( !( UCSR0A & (1<<UDRE0)) );
    //write data to the transmit buffer
    UDR0 = c;
}

/*
 * Receive a character via USART
 * */
char usart_rx_char()
{
    // wait for data to be received
    while ( !(UCSR0A & (1<<RXC0)) );
    // return data from the receive buffer
    return UDR0;
}

/*
 * Transmit a string via USART
 * */
void usart_tx_string(char *p_str)
{
    // loop over the string and transmit character by character
    while(*p_str)
        usart_tx_char(*p_str++);
}

/*
 * Receive a string via USART
 * */
int usart_rx_string(char *p_str)
{
  char c;
  int len = 0;
  while (1)
  {
      // receive a character
      c = usart_rx_char();
      // echo the character back
      usart_tx_char(c);
      // check of a terminator character
      if ((c == '\n') || (c == '\r'))
      {
          // terminate the string with NULL
          p_str[len] = 0;
          // leave the loop
          break;
      }
      // on backspace remove the last character
      else if ((c == '\b') && (len != 0)) 
      {
          len--;
      }
      // copy the character into the string
      else
      {
          p_str[len] = c;
          // increment character count
          len++;
      }
  }
  // return string length to the caller
  return len;
}

/*
 * Transmit integer number
 * */
void usart_tx_int(int i)
{
    // conversion buffer
    char buffer[7];
    // convert integer to character array
    itoa(i,buffer,10);
    // transmit the as string
    usart_tx_string(buffer);
}

int usart_rx_int()
{
    int i = atoi(usart_rx_char());
    // echo back
    usart_tx_int(i);
    return i;
}

void usart_tx_bits(int i)
{
    // conversion buffer
    char buffer[7];
    // convert integer to character array
    itoa(i,buffer,2);
    // transmit the as string
    usart_tx_string(buffer);
}


int main(void) {

    usart_init();

    char str[50];
    int count = 1;

    while(1) {
        usart_tx_int(count);
        // prompt the user
        usart_tx_string(" str> ");
        // wait for input
        int len = usart_rx_string(str);
        usart_tx_char('\n');
        usart_tx_char('\r');
        // echo input string
        usart_tx_string(str);
        usart_tx_char('\n');
        usart_tx_char('\r');
        count++;

        usart_tx_int(count);
        // prompt the user
        usart_tx_string(" int> ");
        usart_rx_int();
        usart_tx_char('\n');
        usart_tx_char('\r');

        count++;
    }

}
