void uart_init(void);

void uart_putchar(char c, FILE *stream);

char uart_getchar(FILE *stream);


/* http://www.ermicro.com/blog/?p=325 */

/*
 * Use a avr-libc standard IO facilities macro to initializer buffers
 * for input and output of type FILE. First and second parameters are 
 * names of the functions which will be called when data is either 
 * read from or written to the buffer.
 */

FILE uart_output = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);
