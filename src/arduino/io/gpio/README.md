
## GPIO (General-Purpose Input/Output)

**Pins** connect the microcontroller electrically to the outside world:

* Most of a microcontroller’s I/O pins can be configured as an **output** or an **input**.
* Special **direction register** will control if a pin is an input or output.
* A pin with **low voltage** (ideally 0V) represents **logic 0**.
* A pin with **high voltage** (close to supply voltage (VCC)) represents **logic 1**.
* **Protective diodes** on every pin should protect the microcontroller in case of over/under voltage.

### Ports

I/O pins are usually configured in **groups of 8 bit** I/O ports. **Ports** are represented by registers inside the microcontroller:

* Allow programs (firmware) to control the **state of pins**
* One-to-one correspondence between the pins on the microcontroller and the bits in its registers.
* If configured as input a **data register** is used to read the state of the pin.

Assembly & high-level language typically includes **instructions to manipulate a single pin** of a port:

* Otherwise a program need to use a **bit mask** when reading the entire port. 
* Port registers may appear in the same memory map as the processor's memory (RAM). 
* Instructions that operate on RAM will also work with the I/O registers.

### Pull Resistors

Internal resistors may create a predictive state (0 or 1) when an in input is read.

* Prevents **signal floating** if the input signals is switching between 0 and 1.
* A **pull-up** resistor sets the input near the supply voltage (logic 1).
* A **pull-down** resistor sets brings the voltage near zero (logic 0). 
* Many MCUs have internal pull resistors controlled by a register.

## Arduino I/O

`D[19:0]` GPIO pins:

Pins  | Description
------|--------------------------------------
0,1   | RX,TX for serial communication
0-7   | Port D[7:0]
8-13  | Port B[5:0]
13    | Connects to the onboard LED
14-19 | Port C[5:0]  (analog input pins 0-5)

Current limits:

- I/O pins can source (provide positive current) or sink (provide negative current) up to **40mA per pin** (high drive)
- All I/O lines should not exceed **200mA total current**, which is the limit of the micro-controller

Library functions:

- Pin behavior is configured with the [pinMode()](https://www.arduino.cc/en/Reference/PinMode) function
- Pins default to `INPUT` mode and are said to be in high-impedance state
- Pins configured to `OUTPUT` mode are said to be in low-impedance state
- The function [digitalWrite()](https://www.arduino.cc/en/Reference/DigitalWrite) sets an output value on pins in  OUTPUT mode
- The function [digitalRead()](https://www.arduino.cc/en/Reference/DigitalRead) reads values from pins in INPUT mode

Digital pins can only have two possible value `HIGH` or `LOW` (pin level):

Mode   | Function         | State | Description 
-------|------------------|-------|----------------------------------------------------------
INPUT  | digitalRead()    | HIGH  | If the voltage is >= maximum input threshold voltage
INPUT  | digitalRead()    | LOW   | If the voltage is <= minimum input threshold voltage
INPUT  | digitalWrite()   | HIGH  | Enable the internal pull-up resistor, unless driven down by externally
OUTPUT | digitalWrite()   | HIGH  | Source maximum output voltage/current
OUTPUT | digitalWrite()   | LOW   | Pin is at 0V, the pin can sink current

The Atmega chip has **pull-up resistors** build in accessible via software:

- **Inverts the behavior of input mode!**
- The value of the pull-up depends on the micro-controller (guaranteed to be between 20kΩ and 50kΩ)

```c
pinMode(pin, INPUT_PULLUP);
// this is the same like using
pinMode(pin, INPUT);           // set pin to INPUT state, if not already an INPUT
digitalWrite(pin, HIGH);       // turn on pullup resistors
```

## AVR I/O 

**8 Bit bi-direction** I/O ports: 

* Three ports `PB[7:0]`, `PC[5:0]`, `PD[7:0]`
* Pins can be configured us input (with/without pull-up) or output (low/high) direction
* All pins have read-modify-write ability and can change direction independently
* Pins have **multiple alternate functions** driven by the internal peripherals
* Each pin can only have **one function assigned** at a time

### Ports

Names if registers and the individual bits are shown in the ATmega manuals.

The port registers are defined by the following variables:

Register | Description
---------|-----------------------------------
DDRx     | defines the data **direction** (in/out) 
PORTx    | **control** the value of a pin
PINx     | used to **read a value** of a pin

* A port is identified by `x` (x = B,C,D) `DDR[B,C,D]`
* **PUD** (Pull Up Disable) bit in the SFIOR Register can be set to disable all pull-ups in all ports.

Pin configuration:

DDRxn | PORTxn | PUD | I/O | Pull-up | Comment
------|--------|-----|-----|---------|------------------------
0     | 0      | x   | in  | no      | tri-state (hi-z)
0     | 1      | 0   | in  | yes     | Pxn sources current (is ext. pulled)
0     | 1      | 1   | in  | no      | tri-state (hi-z)
1     | 0      | x   | out | no      | output low (sink)
1     | 1      | x   | out | no      | output high (source)

### Pins

The port register variables are used as any other variable:

```c
DDRB = 0b00000001
PORTB = 0x0f ;     // 0b00001111
PORTC = 1 << 2     // 0b00000100
```

**Individual bits** can not be read or written in the same way as a full register, but require bitwise operations and masking:

```c
// port manipulation
DDRx |= (1<<PDn);   // Set Pin for output
DDRx &= ~(1<<PDn);  // Set Pin for input
PORTx |= (1<<PDn);  // Set internal pull-up resistor (after setting pin for input)
// digital write
PORTx |= (1<<PDn);  // Set Pin High
PORTx &= ~(1<<PDn); // Set Pin Low
// digital read
if (PINx & (1<<PDn));
```

