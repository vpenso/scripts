

* Runs independent/parallel from the CPU operating a register with a value that increases/decreases
* MCU **internal timer** ticks on the oscillator frequency:
  - The oscillator frequency can drive the timer directly or a pre-scaled.

## TC0 - Timer/Counter0

**TCCR0A** (TC0 Control Register A)

Bit | Name       | Description
----|------------|------------------
7:6 | COM0A[1:0] | Compare Output Mode for Channel A
5:4 | COM0B[1:0] | Compare Output Mode for Channel B
3:2 | -          | -
1:0 | WGM0[1:0]  | Waveform Generation Mode

**TCCR0B** (TC0 Control Register B)

Bit | Name       | Description
----|------------|------------------
7   | FOC0A      | Force Output Compare A
6   | FOC0B      | Force Output Compare B
5:4 | -          | -
3   | WGM02      | Waveform Generation Mode
2:0 | CS0[2:0]   | Clock Select 0

### Modes of Operation

Mode      | Description
----------|---------------------------
Normal    | Counts up (increment), counter overruns (TOP=0xff) sets `TOV0`, no counter clear
CTC       | Match `TCNT0` to (TOP) `OCR0A` to clear counter, generate interrupt with (TOP) `OCF0A`
Fast PWM  | High frequency waveform generation (single-slope), counts from BOTTOM to TOP, then reset
PWM       | High resolution, phase correct PWM waveform generation

* `COM0[A,B][1:0]` Compare Output mode
  - Control whether the output should be set, cleared, or toggled at a compare match (non-PWM mode)
  - Control whether the PWM output generated should be inverted or not (inverted or non-inverted PWM)
* `WGM0[2:0]` sets the counting sequence (how the counter behaves (counts))

WGM0[2:0] | Mode      | Top
----------|-----------|----------
000       | Normal    | 0xff
001       | PWM       | 0xff
010       | CTC       | OCRA
011       | Fast PWM  | 0xff
100       | -         | -
101       | PWM       | OCRA
110       | -         | -
111       | Fast PWM  | OCRa

### Prescaler

**CS0[2:0]** clock select bits

CS0[2:0] | Description
---------|--------------------
000      | No clock source (Timer/Counter stopped)
001      | FCPU/1 (no prescaler)
010      | FCPU/8
011      | FCPU/64
100      | FCPU/256
101      | FCPU/1024
110      | External clock source on T0 pin. Clock on falling edge
111      | External clock source on T0 pin. Clock on rising edge.

```c
TCCR0B = (1<<CS02) | (0<<CS01) | (1<<CS00); // 1024 pre-scalar
```

### Interrupts

**TIMSK0** (TC0 Interrupt Mask Register)

Bit | Name       | Description
----|------------|------------------
7:3 | -          | -
2   | OCIE0B     | Output Compare B Match Interrupt Enable
1   | OCIE0A     | Output Compare A Match Interrupt Enable
0   | TOIE0      | Overflow Interrupt Enable

**TIFR0** (TC0 Interrupt Flag Register)

Bit | Name       | Description
----|------------|------------------
7:3 | -          | -
2   | OCF0B      | Output Compare B Match Flag
1   | OCF0A      | Output Compare A Match Flag
0   | TOV0       | Overflow Flag (set 1 on overflow, set 0 on interrupt handling, write 1 to clear)

`TOV0` is set according to the mode of operation selected by `WGM0[2:0]`

- Can be used to generate a CPU interrupt
- Logic one on overflow, logic zero on interrupt 
- Write logic one to clear

```c
// while the overflow flag is logic zero, wait
while((TIFR0 & (1<<TOV0)) == 0);
// timer overflow has happened
// ...
// clear the overflow flag by writing logic one
TIFR0 |= (1<<TOV0);
```
