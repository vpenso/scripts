## Darlington Transistor

Compound device build from two bipolar transistors:

* Two transistors cascaded to act as single amplifier.
* The **current gain is the product of the two transistors**, therefore it is
  much higher than each transistor taken separately.
* Only a **small input current** is required to switch a large load current.

Used in circuits with motors, relays or other current-hungry components
connected to a low-voltage micro-controller. **Darlington pairs** are available
with a current gain of 1000:1 (i.e. switching a 1A load current with a 1mA
control current).

* The collectors of the two transistors are connected.
* The emitter of the first transistors drives the base of the second transistor.

Disadvantages:

* **High minimum voltage drop** between base and emitter when fully saturated.
  The sum of the two base-emitter voltage drops can be between 0.6V to 1.5V
  depending on the current. This results in a **hotter device** requiring a better
  heat sink.
* **Slow switch times** as it takes longer for the slave transistor to turn the
  master transistors.

