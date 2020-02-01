#include <avr/io.h>
#include <stdio.h>

#include "uart.h"

int main(void) {    

    uart_init();
    // redirect both STDIN and STDOUT to UART
    stdout = &uart_output;
    stdin  = &uart_input;
                
    char input;

    while(1) {
        // strings
        puts("Hello world!");
        // numbers
        printf("%d / %u = %f", 22, 7, (double)22/7);
        // single character
        putchar('\n');
        // register byte in binary 
        printf("0x%08x\n", DDRB);
        // read an input character
        printf("You wrote %c\n", getchar());        
    }
        
    return 0;
}
