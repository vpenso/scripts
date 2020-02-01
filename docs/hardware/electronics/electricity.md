List of quantities, and their units as reference: 

| Quantity   | Symbol | Unit     | Abbr. |
|------------|--------|----------|-------|
| Voltage    | V      | Volt     | V     |
| Work       | W      | Joules   | J     |
| Charge     | Q      | Coulomb  | C     |
| Current    | I      | Ampere   | A     |
| Resistance | R      | Ohms     | Ω     |
| Power      | P      | Watt     | W     |

# Electricity

Electricity is associated with the presence of electric charge:

- Movement (flow) of electric charges is known as electric current (dt. Strom) (moving electrons/ions)
- Electricity is typically defined as having Voltage (dt. Spannung) and the presence of current

**Charge** (Q) (dt. elektrische Ladung) is a property of matter (like mass)

- **Positive** (+) and **negative** (-); **neutral** (absence of a net charge)
- Negative charged electrons, "orbit" an [atoms][01] nucleus with positive charged protons
- Charged particles provide the means to exert electrostatic force (dt. elektrostatische Kraft)
- **Coulomb** (C) unit of electric charge (⇆ **Ampher-hour** (Ah) in electrical engineering)

**Electrostatic force** (also called [Coulomb’s law][02]):

- Charges of the same type **repel**, opposite charges **attract** one another
- Strength of the force is relative to the distance (increases in relation to decreasing distance)

## Energy

**Energy** is the capacity to do work:

- The flow of charged electrons through a conductor creates [electric energy][03]. 
- Electric energy is converted into different forms of energy, i.e. into mechanical energy to spin a motor or into light (electromagnetic energy). A battery converts chemical energy into electrical energy

Electric energy begins as **electric potential energy** (energy stored by a charged particle):

- When set into motion by an electrostatic force, then it becomes **kinetic energy**
- Moving electric charges do [electric work][04] (measured in Volt)

The ability of a particle to do work is called **electric potential**:

- Potential energy is the energy a body has because of its physical position
- Energy is derived/converted from electric **potential energy** (a combination of electric current and electric potential)
- Dissimilar charges have a **potential difference** (pd)

Electric energy is absorbed or delivered by an electric circuit cf. [electric_circuit.md](electric_circuit.md)

## Power

Electric Power (sym. P) is the rate (per unit time) at which electric energy is transfered by an electric circuit to energise electric components. It is measured in the unit **Watt** (abbr. W).

```
P = V  × I       P (watts) = V  (volts) × I (amps)
P = I² × R       P (watts) = I² (ampes) × R (ohms)
P = V² ÷ R       P (watts) = V² (volts) ÷ R (ohms)
```

## Current

Free (valence) electrons move caused of electrostatic force from atom to atom acting as negative **charge carrier**. While electrons drift along a chain of atoms (i. e. within a electric copper wire) a continuous **flow of electrons** is created called electric Current (**I** constant current, **i** (intensity) time-varying current). 

The **flow rate** of electric charges through a given area is measured in Coulomb per second, aka **Ampere** (A) 

- Causes **resistive heating** (flow of current through a conductor produces heat)
- Creates an **electromagnetic field** (cf. motors, inductors, generators)

Kirchoff’s Current Law (KCL): The sum of the currents going into a node is zero

- **Serial components** ⇒ Carry the same current
- **Parallel components** ⇒ Total current equals the sum of currents across all components

## Voltage

Volt is the unit for an **electric potential difference** between two points in space

- Measures the amount of **work required to move an electric charge**
- Caused by the flow of electric current through a magnetic field
- Not an absolute quantity, but a **relative value** between two points in space
- Movement involves a force (unit Newton (N)) and a distance (unit Meter (m))

Measured in Joules per Coulomb, aka **Volt** (V)

- Work in joules required to move one coulomb of charge between two points
- Voltage difference (potential difference) between two points

Voltage is given as `V = W/Q`

* Typically measured between terminals of electric components like resistors, capacitors, and transistors
* Kirchoff’s Voltage Law (KVL): The sum of the voltages around any loop is zero
  - **Parallel components** ⇒ Same voltage across all components
  - **Serial components** ⇒ Total voltage equals the sum of voltages across all components

# Conductivity

_Not all elemental types of atoms have the same capability to release electrons from their orbit. Electrons orbit with varying distance from the nucleus. The closer the orbit around to the nucleus the stronger the attraction to the center. The outermost electrons on the most distant orbit are called valence electrons._

A material is a better conductor the less electrostatic force is required to move valence electrons to create electric current. In other words a material with low resistance (dt. Wiederstand) is a conductor, and a material with high resistance is an insulator (prevents the flow of electrons).

# Resistance

_Current flow depends not only on the voltage pushing current around, but also on resistance (R) of wires, connections and components._

The amount of resistance (dt. Wiederstand) of an object determines weather it is a **conductor** (low resistance) or an **insulator** (high resistance).

An electric conductor (dt. elektrischer Leiter) is an object/material that allows flow of electric current.

- If a voltage is applied across a conductor, a current will begin to flow.
- Good conductors are materials with free electrons: metals (copper), non-metals (carbon, mercury), some acids and salts.

Measured in **Ohm** represented by the letter omega **Ω**:

| Prefix | Abbr. | Value             |
|--------|-------|-------------------|
| Mega   | MΩ    | 10⁶  = 1000000Ω   |
| Kilo   | kΩ    | 10³  = 1000Ω      |
|        | Ω     | 10⁰  = 1Ω         | 
| Milli  | mΩ    | 10⁻³ = 0.001Ω     |
| Micro  | µΩ    | 10⁻⁶ = 0.000001Ω  |

Factors affecting resistance of a material

- Length: The longer the material the more resistance it has (directly proportional). 
- Cross-sectional Area: The thicker the material is he less resistance it has (indirectly proportional).
- Type: The material type affects the flow of free electron, hence its quality as capacitor or insulator.
- Temperature: Material temperature effects its resistance.

**Ohm’s law** describes the relation between voltage, current, and resistance:

- `R` resistance of an object (in ohms Ω)
- `V` voltage across object (on volts V)
- `I` Current going through the object (in amperes A)

```
V = I × R        V (volts) = I (amps) × R (ohms)
I = V ÷ R        I (amps)  = V (volts) ÷ R (ohms)
R = V ÷ I        R (ohms)  = V (volts) ÷ I (amps)
```

**Resistors** (cf. [components/resistors.md](components/resistors.md)) are passive electrical elements used to reduce voltage or current within a circuit. Resistors which obey Ohm's law are **linear resitors**, with a constant resistance (for all voltages and currents).


## Semiconductors

Semiconductors have properties between a conductor and an insulator. They isolate until an electric potential difference is applied across the semiconductor material, which allows flow of current:

- Elements like silicon have multiple free electrons in their most outer shell (valence shell)
- Valence electrons bind with neighboring atoms to form a structure called **crystal lattice** 
- An additional element "**impurity**" is introduced to improve the ability to conduct electricity
- Adding impurity to a semiconductor is called **doping**, the material used is called the **donor**
- A donor adding a surplus of free electrons in the lattice creates an **N-type** semiconductor
- A donor adding an electron hole (missing electron) is known as **P-type** semiconductor

The most Simple application of a semiconductor is a **diode** (cf. [components/diode.md](components/diode.md)) restricting the flow of current in one direction only. Another application is a **transistor** (cf. [components/transistor.md](components/transistor.md)) used to build electronic switches, and signal amplifiers. 



[01]: https://en.m.wikipedia.org/wiki/Atom
[02]: https://en.m.wikipedia.org/wiki/Coulomb%27s_law
[03]: https://en.m.wikipedia.org/wiki/Electrical_energy
[04]: https://en.m.wikipedia.org/wiki/Work_(electrical)

