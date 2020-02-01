# Integrated Circuit

Integrated Circuits (ICs) are a keystone of modern electronics:

* Collection of electronic components: resistors, transistors, capacitors.
* Integrated (packaged) into a small chips.
* Typical applications:
  - Logic gates 
  - Timers
  - Voltage regulators
  - Micro controllers
  - Micro processors

# Packages

The **package** encapsulates the IC into a single device:

* Different [packaging types][01] with unique dimensions, 
  mounting-types, and pin-counts.
* ICs are **polarized** and every pin is unique in term of 
  location and function.
* **Notch** and/or **dot** indicates the first pin.
* Pin numbers increased sequentially counter-clockwise 
  around the chip.

## Mounting Types

**Through-hole** components have terminals (lead wires) that are 
led to the board through holes, and soldered at the opposite side:

- Come in two basic types: axial (i.e. resistors) and radial 
  (i.e. capacitors)
- Good for manual prototyping, can be used with a breadboard
- **DIP** (Dual Inline Packaging)

**SMD** (Surface Mounted Devices) are directly soldered to the 
board than then using hole mounting

- Smaller components allows higher component density and more connections
- Cheaper components, easier for assembly automation
- Components can be placed on both sides of the circuit board
- Lower resistance and inductance at the connection
- Component-level repair more difficult
- Unsuitable for high-power/voltage

## DIP

[DIP][02] (Dual in-line package), most common through-hole IC package:

* Two parallel rows of pins extending perpendicular out or a 
  rectangular plastic housing.
* Pins are spaced by 2.54mm standard spacing perfect for 
  breadboards.
* Overall size depends on the pin count between 4 up to 64.
* The package width allows placement in the center of a
  breadboard.

# Logic Devices

Digital Logic Families:

* Classified broadly according to the technology they are build on
* Logic families include:
  - Diode Logic (DL)
  - Resistor-Transistor Logic (RTL)
  - Emitter Couple Logic (ECL)
  - Transistor-Transistor Logic (TTL)
  - CMOS (Complementary Metal Oxide Semiconductor)

Within each family, several subfamilies are available with different:

* Propagation delay (speed rating)
  - Average transition delay time for the signal from input to output.
  - Expressed in nano-seconds (ns)
* Power dissipation: Power consumed by the gate when fully driven by all inputs.
* Temperature ranges
* Voltage level
* Current level

## Nomenclature

* Standardized manufacturer independent numbering scheme for basic parts
* Prefix of the part number represents the **manufacturer code**:
  - **S** Signetics
  - **SN** Texas Instruments
  - **DM** National Semiconductor
* The suffix at the end donates the **packaging type**:
  - **N** plastic dual in line package
  - **W** ceramic flat pack
  - **D** surface mounted plastic package

The middle suffix donates the **subfamily**:

| Suffix   | Delay | Power | Comment                                                       |
|----------|-------|-------|---------------------------------------------------------------|
| 74       | 10ns  | 10mW  | Standard TTL                                                  |
| 74L      | 33ns  | 1mW   | Low-power TTL (replaced by CMOS logic)                        |
| 74H      | 6ns   | 22mW  | High-speed TTL                                                |
| 74S      | 3ns   | 19mW  | Schottky-clamped transistors                                  |
| 74LS     | 9.5ns | 2mW   | Low-power Schottky                                            |
| 74ALS    | 4ns   | 1mW   | Advanced low power Schottky                                   |
| 74F      | 3.4ns | 6mW   | reduced propagation delay from LS and ALS                     |
| 74C      |       |       | CMOS logic pin compatible to TTL                              |
| 74HC     |       |       | CMOS high-speed pin compatible to TTL                         |
| 74HCT    | 16ns  | 1uA   | CMOS input/output voltage compatible to TTL                   |

## Logic Devices

List of 7400 series integrated circuits:

| Name      | Comment                     |
|-----------|-----------------------------|
| 74..00    | Quad 2-input NAND gate      |
| 74..02    | Quad 2-input NOR gate       |
| 74..04    | Hex inverter NOT gate       |
| 74..08    | Quad 2-input AND gate       | 
| 74..10    | Triple 3 input NAND gate    | 
| 74..11    | Triple 3-input AND gate     |
| 74..20    | Dual 4-input NAND gate      |
| 74..21    | Dual 4-input AND gate       |
| 74..27    | Triple 3-input NOR gate     |
| 74..30    | Single 8-input NAND gate    |
| 74..32    | Quad 2-input OR gate        | 
| 74..260   | Dual 4-input NOR gate       |


[01]: https://en.m.wikipedia.org/wiki/List_of_integrated_circuit_packaging_types
[02]: https://en.m.wikipedia.org/wiki/Dual_in-line_package
[03]: https://en.m.wikipedia.org/wiki/7400_series
[04]: https://en.wikipedia.org/wiki/4000_series
[05]: https://en.wikipedia.org/wiki/HCMOS
