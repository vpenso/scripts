
List of files in this example:

File         | Format | Description
-------------|--------|------------------
`blink.c`    | ASCII  | C program source code (higher programming language)
`blink.eln`  | ELF    | Relocatable binary-object file (output from the assembler, input to the linker)
`blink.elf`  | ELF    | Executable binary-object file (output from the linker) 
`blink.hex`  | ASCII  | Hexadecimal encoded binary machine code loaded to the MCU ROM
`blink.lst`  | ASCII  | List-file with assembler source and interspaces C source code
`blink.map`  | ASCII | Map-file showing symbol reference to modules(/libraries)

## Compile

The `avr-gcc` program **compiles C-code** for **Atmel AVR** micro-controllers (MCUs):

* `-mmuc` specifies the MCU type (cf. [Machine-specific options for the AVR](http://www.nongnu.org/avr-libc/user-manual/using_tools.html))
* `-g` - Embed debug info later disassembling (inflates the code!)
* `-c` - Disable linking, will be down in an additional step

```bash
avr-gcc -mmcu=atmega328p -g -c -o /tmp/blink.eln $AVR_HOME/src/blink.c # compile
avr-gcc -mmcu=atmega328p -g -o /tmp/blink.elf /tmp/blink.eln # link
```

The `avr-objdump` program  **manipulats object files**: 

* `-S` - Disassembles the binary file and intersperses the source code.
* The result list-file allows to better understand the translation between assembler and C-code

```bash
avr-objdump -h -S /tmp/blink.elf > /tmp/blink.lst # disassemble
```

Generate a map-file during linking which shows where modules are loaded and which modules were loaded from libraries.

```bash
avr-gcc -mmcu=atmega328p -g -Wl,-Map,/tmp/blink.map -o /tmp/blink.elf /tmp/blink.eln # re-link
```

## Upload

The binary format ELF (Executable and Linking Format) is not compatible with flash program.

Extract the required segments from the object-file and encode into hex:

```bash
avr-objcopy -j .text -j .data -O ihex /tmp/blink.elf /tmp/blink.hex
```

Write the hex-encoded program to the Arduino Uno ROM (memory) and reset the MCU:

```bash
avrdude -p atmega328p -c arduino -P /dev/ttyACM0 -U flash:w:/tmp/blink.hex:i
```

Options to `avrdude` depend on the Arduino used. The following configuration is used to an Arduino Nano:

```bash
avrdude -p atmega328p -c arduino -P /dev/ttyUSB0 -b 57600 -U flash:w:/tmp/blink.hex:i
```

### Script

A simple **shell-script to compile and flash** a single file program to an Arduino:

```bash
# defaults fot the Arduino Uno
export AVR_DEVICE=/dev/ttyACM0 
export AVR_MCU=atmega328p
export AVR_BAUDRATE=115200

function avr-upload() {
  local source=$1
  local name=${source%%.*}
  local object=/tmp/$name.elf
  local hex=/tmp/$name.hex
  avr-gcc -mmcu=$AVR_MCU -o $object $source && \
  avr-objcopy -O ihex $object $hex && \
  avrdude -q -p $AVR_MCU -c arduino -P $AVR_DEVICE -b $AVR_BAUDRATE -U flash:w:$hex:i
}
```

