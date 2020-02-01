# Field-effect transistor (FET)

_Another three terminal semiconductor device to switch and amplify, developed to
overcome the limitations of BJT transistors._

Terminals in comparison to BJT transistors:

| BJT           | FET        |
|---------------|------------|
| Emitter (E)   | Source (S) |
| Base (B)      | Gate (G)   |
| Collector (C) | Drain (D)  |

IGFET (Insulated Gate FET) transistors:

* **Gate terminal isolated** from the main current carrying channel (no current
  flows into the gate)
* Act like a voltage controlled resistor, current flows through the **main
  channel between drain and source**, proportional to the input voltage
* **High input impedances** (MΩ), draws negligible current from the circuit
* Two types **JFET** (Junction Field Effect Transistor), and the most commonly
  used type **MOSFET** (Metal-Oxide Field-Effect)

Classifications into **PMOS** (P-channel) or **NMOS** (N-channel)

* Constructions consists of a resistive semiconductor "channel" carrying the
  current through the FET
* This main channel may be made out of P-type of an N-type semiconductor material

## MOSFET

Two basic forms:

* **Depletion Type** (normally-on) requires a gate-source voltage to switch off
* **Enhancement Type** (normally-off) requires a gate-source voltage to switch on

Switching tables according to the gate-source voltage (VGS):

| Type             | VGS = +V | VGS = 0V | VGS = -V |
|------------------|----------|----------|----------|
| NMOS Depletion   | on       | on       | off      |
| NMOS Enhancement | on       | off      | off      |
| PMOS Depletion   | off      | on       | on       |
| PMOS Enhancement | off      | off      | on       |
