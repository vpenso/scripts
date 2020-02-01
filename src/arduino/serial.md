# AVR Serial Communication

The Arduino uses UART to:

* **Upload a program** from the computer to the Arduino
* Connects with a **serial monitor** to send and receive data from an Arduino during program execution

Arduino has at least one **serial port** connected to the micro-controller:

* Data transmission on the serial port is indicator by the TX/RX LEDs on the board
* **TX** means transmit and **RX** means receive 
* Also connected to pins 0 (RX) and 1 (TX)
* Dedicated chip to convert the hardware serial port (TTL) to USB (Universal Serial Bus) 

AVR USART features:

* Full duplex operation, RX (receive) & TX (transmit) at the same time
* Synchronous or asynchronous
* High resolution baud rate generator (minimum error)
* 5 to 9 data bits, 1 or 2 stop bits, odd/even parity generator
* Double speed asynchronous communication mode
* 3 interrupt sources (TX complete, RX complete, TX data register empty)
* Supports SPI mode

## Baud Rate (Transmission Speed)

12-bit register contains the USART baud rate

Register    | USART Baud Rate
------------|-------------------------
UBRR0H[3:0] | Baud Rate 0 Register High
UBRR0L[7:0] | Baud Rate 0 Register Low

Status register:

Bit | UCSR0A | Control and Status Register 0 A
----|--------|------------------------------------
1   | U2X0   | Double Transmission Speed 

* Writing `UBRR0L` will trigger an immediate update of the baud rate pre-scaler
* Ongoing transmissions corrupted if the baud rate is changed
* External clock pin XCK (PD4)
* **U2X0** enables double transmission speed in asynchronous operation
  - Logic zero in synchronous operation
  - Logic one will reduce the divisor of the baud rate divider from 16 to 8 effectively doubling the transfer

```c
UCSR0A |= (0<<U2X0) // single transmission speed
UCSR0A |= (1<<U2X0) // double transmission speed
```
```
UCSR0A |= (0<<U2X0)
UBRR0L = 103 // 9600bps@16MHz
UBRR0L = 25 // 115.2kbps@16MHz
UBRR0L = 0 // 1Mbps@16MHz

UCSR0A |= (1<<U2X0)
UBRR0L = 1 // 1Mbps@16MHz
UBRR0L = 0 // 2Mbps@16MHz
```

## Configuration

Bit | UCSR0A | Control and Status Register 0 A
----|--------|------------------------------------
0   | MPCM0  | Multi-processor Communication Mode

Bit | UCSR0B | Control and Status Register 0 B
----|--------|------------------------------------
4   | RXEN0  | Receiver Enable
3   | TXEN0  | Transmitter Enable
2   | UCSZ02 | Character Size (combined with UCSR0C.UCSZ0[1:0])

```c
UCSR0B |= (1<<RXEN0) | (1<<TXEN0); // enables the USART transmitter/receiver
```

Bit | UCSR0C      | Control and Status Register 0 C
----|-------------|------------------------------------
7:6 | UMSEL0[1:0] | Mode Select
5:4 | UPM0[1:0]   | Parity Mode
3   | USBS0       | Stop Bit Select
2:1 | UCSZ0[1:0]  | Character Size (combined with UCSR0B.UCSZ02) 
0   | UCPOL0      | Clock Polarity XCK0 (logic zero falling, logic one rising)

Select from these configurations:

```c
// USART Mode Select
UCSR0C |= (0<<UMSEL01) | (0<<UMSEL00); // asynchronous (default)
UCSR0C |= (0<<UMSEL01) | (1<<UMSEL00); // synchronous
UCSR0C |= (1<<UMSEL01) | (1<<UMSEL00); // master SPI

// USART Parity Mode
UCSR0C |= (0<<UPM01) | (0<<UPM00); // disbaled (default)
UCSR0C |= (1<<UPM01) | (0<<UPM00); // enable, even parity
UCSR0C |= (1<<UPM01) | (1<<UPM00); // enable, odd parity

// USART Stop Bit Select
UCSR0C |= (0<<USBS0); // 1-bit (default)
UCSR0C |= (1<<USBS0); // 2-bit

// USART Character Size / Data Order
UCSR0C |= (0<<UCSZ02) | (0<<UCSZ01) | (0<<UCSZ00); // 5-bit (default)
UCSR0C |= (0<<UCSZ02) | (0<<UCSZ01) | (1<<UCSZ00); // 6-bit
UCSR0C |= (0<<UCSZ02) | (1<<UCSZ01) | (0<<UCSZ00); // 7-bit
UCSR0C |= (0<<UCSZ02) | (1<<UCSZ01) | (1<<UCSZ00); // 8-bit
UCSR0C |= (1<<UCSZ02) | (1<<UCSZ01) | (1<<UCSZ00); // 9-bit
```

## Transmit/Receive

Data registers (receive pin RxD (PD0), transmit pin TxD (PD1)):

UDR0     | I/O Data Register
---------|--------------------
TXB[7:0] | TX Transmit buffer
RXB[7:0] | RX Receive buffer

Bit | UCSR0B[1:0] | Control and Status Register 0 B
----|-------------|---------------------------------
1   | RXB80       | Receive Data Bit 8
0   | TXB80       | Transmit Data Bit 8

Status registers:

Bit | UCSR0A | Control and Status Register 0 A
----|--------|------------------------------------
7   | RXC0   | Receive Complete
6   | TXC0   | Transmit Complete
5   | UDRE0  | Data Register
4   | FE0    | Frame Error
3   | DOR0   | Data OverRun
2   | UPE0   | Parity Error

* TX and RX share the same I/O address referred **UDR0**
  - UDR0 holds data for 5 to 8-bit communication 
  - Data bit 9 in combination with `UCSR0B.RXB80` or `UCSR0B.TXB80`
* **UDRE0** indicates whether the transmit buffer is ready to receive new data
  - Set when the transmit buffer is empty
  - Cleared when the transmit buffer contains data to be transmitted
  - Write logic 0 before writing the`UCSR0A`
* **TRX0** used for half-duplex communication interfaces (RS-485) 
  - Set when no new data is in the transmit buffer
  - Cleared on a transmit complete interrupt
  - Write logic one to clear
* **RXC0** indicates unread data present in the receive buffer
  - Logic one unread data exist in the receive buffer
  - Logic zero receive buffer is empty
  - Executes the receive complete interrupt
  - Receive complete routine must read buffer to clear flag
* Error flags `FE0`, `DOR0`, and `UPE0` must be read before the receive buffer
  - **FE0** state of the first stop bit (logic zero when the stop bit was correctly read as '1')
  - **DOR0** indicates data loss due to a receiver buffer full condition (logic one if serial frames were lost)
  - **UPE0** indicates that the next frame had an parity error

### Transmit

Wait for empty transmit buffer and write 8-bit:

```c
while ( !( UCSR0A & (1<<UDRE0)) ); // wait for empty transmit buffer
UDR0 = data; // read from the receive buffer
```

Similar with bit 9 in `UCSR0B.TXB8`

```c
while ( !( UCSR0A & (1<<UDRE0)) ); 
UCSR0B &= ~(1<<TXB80);
if ( data & 0x0100 )
  UCSR0B |= (1<<TXB80);
UDR0 = data;
```

### Receive

Receiving Frames with 5 to 8 Data Bits:

* Starts data reception when it detects a valid **start bit**
* Following bits sampled at the **baud rate** or XCK0 clock
* First **stop bit** completes serial frame in receive buffer

Poll `RXC` receive complete flag, before read of the receive buffer via `UDR0` 

```c
// wait for data to be received
while ( !(UCSR0A & (1<<RXC0)) )
// up to 8-bit receive
data = UDR0
```

9-bit receive with `UCSR0B.RXB8`:

* Read status flags `FE0`, `DOR0` and `UPE0` first
* Read `RXB8` before reading the low bits from the `UDR0`
* Rads all the I/O registers before computation to free the buffer to accept new data as early as possible

```c
unsigned char status, resh, resl;
while ( !(UCSR0A & (1<<RXC0)) )

status = UCSR0A;
resh = UCSR0B;
resl = UDR0;

if ( status & (1<<FE0)|(1<<DOR0)|(1<<UPE0) )
  return -1;

resh = (resh >> 1) & 0x01;
return ((resh << 8) | resl);
```

### Interrupt

Bit | UCSR0B | Control and Status Register 0 B
----|--------|------------------------------------
7   | RXCIE0 | RX Complete Interrupt Enable
6   | TXCIE0 | TX Complete Interrupt Enable
5   | UDRIE0 | Data Register Empty Interrupt Enable

Interrupt vectors on Atmega328p (AVR-Libc reference - Library Reference - `<avr/interrupt.h>`):

Vector             | Description
-------------------|-------------------
USART_RX_vect      | RX Complete
USART_TX_vect      | TX Complete
USART_UDRE_vect    | Data Register Empty



