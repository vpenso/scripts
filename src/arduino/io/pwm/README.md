# PWM - Pulse-Width Modulation

Generates **analogue signals** (voltage levels) from a digital device

* Still a digital signal with a defined time period between on and off (high/low)
* Generates a **square wave** instead of a constant voltage
* If the frequency is sufficiently high the output can be adjusted anywhere between 0-100%
* The **duty Cycle** describes the time in percent (proportion) the output/signal is high over a constant time interval

Disadvantage: _Power/energy delivered is not continuous_

* If a high frequency is not sufficient use additional passive electronic filters
* Filters smooth the pulse to recover an analog waveform

Common applications:

* Control dimming of RGB LEDs
* Control the direction/angel of a servo motor
* Control the speed of a fan
* Voltage regulators (usually filtered with an inductor & capacitor)
* May be used to encode a message into a pulsing signal to transmit information

## Arduino Analog Write

`D[3,5,6,9,10,11]` pins with PWN support (marked with `~`):

- Duty-cycle pulse stream at approx. @490Hz frequency
- Limited to 8bit resolution, values from `0` up to `255`

[analogWrite(pin,dutyCycle)](https://www.arduino.cc/en/Reference/analogWrite)

