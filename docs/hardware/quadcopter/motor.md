

* **Weight**
  - Total weight of the vehicle, including payload (battery, HD cam)
  -  Frame size limits propeller size which limits motor size
* Electric **Power**
  - Measures in **W** (Watt)
  - `Voltage (V) * Current (A)` (voltage multiplied by current)
* **Current Rating**
  - Maximum current motor can handle
  - Measured in **A** (Ampere)
* **Thrust**
  - Measures in **g** (Gram)
  - Higher thrust equates in higher top speed, and higher current drawn
  - Full thrust needs to be supported by the batteries maximum discharge rate (C-Rating)
* **Torque** (N.m)
  - Measures **Angular Force**
  - How much "push" the rotation shaft has
* **RPM** Rounds Per Minute
  - Measures **Angular Speed**
  - How fast the motor rotates the propeller
  - **Response**, how fast the motor changes RPM
* **Efficiency**
  - `Thrust (g)/Power (W)` (trust divided by power)
  - Higher efficient, means less power consumed
  - Power not transformed to trust dissipates as heat
* **Kv** Number/Rating
  - RPM per volt supplied to the motor
  - Rating assumes no load on the motor, and constant voltage
  - `1200kv * 3V = 3600rpm`
* **Thrust to Weight Ratio**
  - 2:1 minimum
  - 3:1, 4:1 normal
  - up to 8:1 for race (more agility, harder to control)
* 4-digit number `AABB`, `AA` stator width, `BB` height

### Brushed

* Pro
  - Low cost
  - Simple control (no controller required for fixed speed)
  - 2 control wires
* Con
  - Brushes wear off because of friction (stop conducting electricity)
  - Speed/torque moderately flat (brush friction increases at higher speed)
  - Poor heat dissipation (due to internal construction)
  - Higher rotor inertia (less dynamic)
  - Lower speed range (mechanical limits on the brushes)
  - Brush arcing generates causes interference (EMI, noise)

### Brushless

* Pro
  - More durable (due to absence of brushes)
  - Speed/torque flat
  - High efficiency (no voltage drops)
  - High output power to size ratio
  - Better heat dissipation
  - High speed range
  - Lower electric interference
* Cons
  - Higher cost
  - Requires ESC (Electric Controller) 




