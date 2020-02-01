# 74C595 Shift Register

Shift registers are often used to **save I/O pins** on a micro-controller

| Pin(s) | Number     | Comment                            |
|--------|------------|------------------------------------|
| Q0-Q7  | #0[1-7],15 | 8x data pins                       |
| GND    | #08        | Ground (0V)                        |
| Q7S    | #09        | Serial data output                 |
| MR     | #10        | Mater reset (active low)           |
| SHCP   | #11        | Shift register clock input         |
| STCP   | #12        | Storage register clock input       |
| OE     | #13        | Output enable input (active low)   |
| DS     | #14        | Serial data input                  |
| VCC    | #16        | Supply voltage (2-6V)              |
 
Pin configuration:

![shift_register.jpg](shift_register.jpg)

