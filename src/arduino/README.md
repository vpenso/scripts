# Arduino

Arduino is an **open-source ecosystem** including:

* Hardware schematics, and PCB layouts for the Arduino micro-controller boards.
* A bootloader for the Arduino platform, and a Software Development Kit (SDK).
* A cross-platform Integrated Development Environment (IDE) (written in Java).

Arduino is build with an **AVR Atmel micro-controller**, the required power supply,
a clock crystal, and female input/output pins to interface with peripherals.

Arduino exist in many flavors: Uno, Leonardo, Mega, Nano, Mini, etc.

I.e. the Arduino UNO R3 hosts an ATmega328 micro-controller:

* Low-power CMOS **8bit** micro-controller (AVR enhanced RISC architecture)
* Available as through-hole DIP, and as surface mounted device (SMD)
* Runs with **16Mhz** clock speed at 5V
* **32kB Flash** non-volatile memory (to store programs persistently)
* **2kB SRAM** random access memory used to store program run-time data
* **1kB EEPROM** non-volatile memory for system configuration

The **host Computer** is the workstation of the programmer:

* Used to implement software for the micro-controller on the Arduino board
* Used to translate (compile) this software into the micro-controller binary machine-code
* Used to transfer the binary code onto the flash memory on the Arduino board
 
The **target computer** is the Arduino itself connected via USB.

Typical development cycle in steps:

1. **Write code** for the Arduino micro-controller, a program.
2. **Compile** this program into (binary) machine-code understood by the micro-controller
3. **Transfer the machine-code** to the Arduino device micro-controller
4. **Execute** the program on the micro-controller for testing & debugging
5. **Repeat**

