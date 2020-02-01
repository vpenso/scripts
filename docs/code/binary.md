# Binary

Electronic devices operate on **binary** signals (electricity on/off):

* Binary expressed by two symbols - `0` and `1` ➜  **binary digits** (bits)
* By **encoding** (interpreting) sets of bits in various ways:
  - Computers determine what to do (instructions)...
  - ...and represent/manipulate numbers, strings, etc.
* Numbers, text represented as **binary patterns** ➜  combinations of 0 and 1
* Bits are representable by any mechanism capable of distinguishing two states
  - Digital electronics uses two different voltages
  - Magnetic devices use two polarities

Example binary patterns (8bit ASCII encoding):

Binary     | Character
-----------|------------
0011 0000  | 0 (zero)
0011 0010  | 1 (one)
0011 0010  | 2 (two)
0100 0001  | A
0100 0010  | B
0100 0100  | C

## Numbers

* **Binary Number**: Numbers expressed in the **base-2** binary numeral system
* **Binary System**
  - Uses Arabic numerals **0** (zero) and **1** (one) to represent a bit state
  - Each digit represents an increasing **power of 2** 
  - Rightmost digit 2⁰, next 2¹, then 2², and so on

Convert the binary number **42** into decimal:

```
101010 = 1×2⁵ + 0×2⁴ + 1×2³ + 0×2² + 1×2¹ + 0×2⁰
101010 = 1×32 + 0×16 + 1×8  + 0×4  + 1×2  + 0×1
101010 =   32 +          8  +          2         = 42
```

Bitwise **Arithmetic** like addition, subtraction, multiplication, and division
are similar to decimals.

```bash
# cf. var/aliases/bc.sh
>>> dec2bin 12345
0b11000000111001
>>> bin2dec 1011010101110
5806
```

## Bit Operators

Bitwise operators:

```
Operator | Description
---------|------------
 ~       | complement
 >>      | right shift
 <<      | left shift
 &       | bitwise AND
 |       | bitwise OR
 ^       | bitwise XOR
```

Bitwise operator rules:

  A  |  B  | AND | OR | XOR
-----|-----|-----|----|-----
0    | 0   | 0   | 0  | 0
0    | 1   | 0   | 1  | 1
1    | 0   | 0   | 1  | 1
1    | 1   | 1   | 1  | 1

Cf. `src/c/bitop.c`, and `src/cbitlogic.c`

