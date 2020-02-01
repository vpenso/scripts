#include <avr/io.h>
#include <stdio.h>


// avr-libc macros for baud rate calculation 
// requires F_CPU and BAUD to be defined
#ifndef F_CPU
#define F_CPU 16000000UL
#endif
#ifndef BAUD
#define BAUD 9600
#endif
// include helper macros for baud rate
#include <util/setbaud.h>
// defines: UBRRL_VALUE, UBRRH_VALUE and USE_2X

/* http://www.cs.mun.ca/~rod/Winter2007/4723/notes/serial/serial.html */

void uart_init(void) 
{
// 12-bit registers contains the USART baud rate
UBRR0H = UBRRH_VALUE; // set upper byte of the calculated pre-scaler value
UBRR0L = UBRRL_VALUE; // set lower byte of the calculated pre-scaler value
    
// USART Control and Status Register 0 A
#if USE_2X
// desired baud rate tolerance could only be achieved by setting the U2X bit
    UCSR0A |= (1<<U2X0); 
    // set logic 1 to double the USART Transmission Speed
#else
    UCSR0A &= ~(1<<U2X0);
    // logic 0 using synchronous operation
#endif

// USART Control and Status Register 0 C
UCSR0C = (1<<UCSZ01) | (1<<UCSZ00); // 8-bit data
// USART Control and Status Register 0 B
UCSR0B = (1<<RXEN0) | (1<<TXEN0); // Enable RX and TX 
}

void uart_putchar(char c, FILE *stream)
{
    // adding a carriage return after newline has been sent
    if (c == '\n') {
        uart_putchar('\r', stream);
    }
    // Wait until USART Data Register Empty UDRE flag is set
    loop_until_bit_is_set(UCSR0A, UDRE0);
    // write a byte to USART Data Register
    UDR0 = c;
}

char uart_getchar(FILE *stream)
{
    // USART Receive Complete RXC0 flag is set if 
    // unread data exists in data register
    loop_until_bit_is_set(UCSR0A, RXC0);
    // reade a byte from USART Data Register
    return UDR0;
}
