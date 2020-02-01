# Serial Communication


Serial data transmission (one single bit at a time) between digital devices:

* Umbrella word for all that is **time division multiplexed** (data sent spread over time)
* Opposite of parallel data transmission (multiple bits at the same time)
* Basic serial communication require one wire, typically **2 wires** are used (never more than four)

Synchronous or asynchronous serial interface:

* **Synchronous**, pairs data line(s) with clock signal
  - All devices on the serial bus share a common clock
  - Faster serial transfer, requires (at least) one extra wire
  - Common clocked serial protocols:  SPI, I2C
* **Asynchronous**, no common clock signal
  - Data stream includes synchronization information
  - Minimize required wires and I/O pins
  - Common clock-less serial protocols: 

Commonly "serial" is used synonymously with asynchronous serial.

Serial hardware implementation:

* Send data over an communication **channel**
* Data transmitted **sequentially** over a single channel
* Data send/receive as **electrical pulses**
  - 0V for logic zero and nowadays 5V (or 3.3V) as logic one 
  - Cf. **TTL** transistor-transistor logic level, and RS-232

The **baud rate** defines speed of communication in bps (bits per second)

* Determines how long the transmitter holds a serial line high/low 
* _Baud rate missmatch_ happens when communication devices use different transmission speeds
* Standard baud rates: 1200, 2400, 4800, 9600, 19200, 38400, 57600, and 115200

## Synchronous Serial

**SPI** (Serial Peripheral Interface):

* Master sends a clock signal, each clock pulse shifts one bit to the slave (out), and one bit from the slave (in)
* **Signal names**: 
  - `SCK` clock, `MOSI` master out slave in, and `MISO` master in slave out
  - `SS` slave select, master controls more than one slave on the serial bus

**I2C** (Inter-Integrated Circuit), pronounced "I squared C":

* **2 wires**, **clock** (SCL) created by the master, **data** (SDA) master and slave share the same wire
* Devices have a **7 bit address**, with a maximum of 127 devices on the bus
* **read/write bit** indicates data direction of the next byte(s), `0` to acknowledge reception 

Atmel uses **TWI** (2-wire interface) which is exactly same as I2C

## Asynchronous Serial

An asynchronous serial protocol requires mechanisms to ensure robust, error-free data transfer:

* Uses **data frames** (packets) to encapsulate a data block (chunk) to transfer
* The **data block** has a variable size (typically 5 to 9 bit), i.e. 7 bit for ASCII
* Each data frame includes **synchronization bits** (start/stop bit(s)) and **parity bits**
* 2 wires for communication **RX** receiver, **TX** transmitter, and **GND** ground
* RX/TX with respect to the device, **transmitter wired to the receiver**
* **Full duplex** means both communication partners send/receive data simultaneously

**UART** (Universal Asynchronous Receiver/Transmitter), physical circuit (dedicated IC, or integrated within a MCU) implementing serial communication:

* UARTs communicate directly with each other (not a protocol like SPI or I2C)
* Converts parallel (8 bit) data from a controlling device (MCU/CPU) into serial data and vice versa
* More advanced UARTs use a buffer for received data (FIFO)
* USART (Universal Synchronous/Asynchronous serial Receiver/Transmitter)

