# LiPo

* **LiPo** (Lithium Polymer battery), high energy density, very high discharge and charge rates
  - Fairly flat discharge rate until 10% remaining capacity, followed by a sharp voltage drop
  - Never discharge below 80% capacity, eg. `850mAh * 0.2 = 170mAh`
* **Pack Configuration**
  - **S** number of serial cells (raises voltage)
  - **P** number of parallel cells (raises capacity)
  - "1S" single cell, 3.7V
  - "3S" three serial cells, 11.1V (3x 3.7V)
* Capacity measured in **mAh** (milli-Amp-hour), 1/1000th of an Ah

## Cell Balancing

* Allows monitoring and manipulation of each battery cell in a battery pack individually
* **Cell imbalance**
  - Damages the cell, results in a fire in extreme cases (e.g. over-charging)
  - Goal: **Make all cells in a pack the same voltage**
* Majority of cell packs come with a **Cell Balancer**
* Requires a **Balancing Charger**
  - Monitors individual cell voltage
  - Discharges high voltage cells in order to balance the pack
* **Balance Connector**, break out connector to access all individual cells
* _Vendor specific wiring of the balancing connector_
  - Plugs may be the same, but differ in the wiring
  - Types: TP (Thunder Power), JST-XH, Hyperion (Polyquest)
  - Balance-Adapter: single use adapter, adapter board

### C-Value

* **C** tied to the capacity
  - Continuous discharge at **1C** depletes the battery in **1 hour**
  - Similar charging at 1C takes 1 hour
  - 2C cuts time to 1/2, 3C to 1/3, etc.
* Calculating C, e.g.:
  - `2200mAh/1000=2.2Ah` (drop "h") `C=2.2A`
  - `850mAh` `C=.85A`
  - only the capacity is used to determine C
  - number of cells S/P has no impact

### Rates

* Calculate **Charge Rate**
  - 1C (`1*C`) `1*2.2A=2.2A`
  - 2C `2*2.2A=4.4A`
  - 5C `5*2.2A=11A`
* Charging rates beyond 1C is considered fast charging
* **C-Rating** output capability
  - `25C/40C` continuous discharge rating/burst discharge rating
* Calculate **Maximum Continuous Discharge Rate**
  - 25C `25 * C = 25 * 2.2A = 55A`
  - 30C `30 * C = 30 * 5A = 150A`

## Handling

* Shelf time in **"sleep" state**
  - 3.85V per cell
  - Chemical stabilizer lost when cells are cycled
* **"Break in" process** during the first few cycles
  - Charge slowly **1C**
  - Gently discharging to 50% capacity for the first 5 flights
  - "loosens" cells for normal duty
* Battery Log
  - Discharge & charge date
  - Battery cycles
  - mAh replace during charge
  - Battery IR (Internal Resistance) to monitor health

### Safety & Longevity

* Pick up on the body, not the connection wires (prevents breaking solder points)
* Keep away from objects which can penetrate the cell wall (leads to fire)
* Internal **Temperature**
  - Stay below 130F/60C
  - Rule of thumb: if a lipo is too warm to hold tightly in your hand, it is too hot
* **Internal Resistance** (IR)
  - Used to determine the quality/health of a pack
  - the lower the IR the easier current flows

### Charging

* Goal: Charge to a specific voltage, number of cells multiplied by 4.2V
  - Resting Voltage: Checked to determine charge state
  - During this process the resting voltage rises
* DON'T
  - Charge if the battery is sill hot from resent use
  - **Never leave the charger unattended!**
  - Explosion of a LiPo possible due to **over-charging** (wrong charger configuration, cell count)
  - _Never charge above 4.2V per cell_ (full charge voltage)
* DO
  - Charge in something flameproof, e.g. safe-bag (bath-tube, oven, etc.)
  - Choose appropriate **charge rate**
  - Charge **up to 4.1V**, eventually up to 4.2 immediately before use
  - **Double check** charger configuration before start, and once during charge cycle
  - **Failure response**: unplug charger, prepare (outdoor) save place for the LiPo
  - Have a fire extinguisher at hand

### Discharge

* 80%-rule (never discharge below 80% of its rated capacity (mAh))
* _Never discharge below 3.6V_ (cells below 3V minimum voltage may defect)

## Storage

Storing long term >week at 40-50% capacity (never fully charged)

* Voltage: **3.7-3.75V** per cell, check regularly (every month), recharge eventually
* Store in **LiPo Safe-Bag**
* Environment: Cold, dry, away from flammable objects (ammo can, metal tool box, fire proof safe)
* Use a charger with **storage charge feature** and a discharge feature
* **Battery Monitor**
  - Device that plugs into the balance leads
  - Beep when voltage of the battery gets low
  - Some include a display to show voltage of individual cells

### Damage

* Damage
  - Physically damages LiPos should be disposed immediately
  - This includes punctured, crushed or swollen cells/packs
  - Disconnected wires should be fixed by an expert!
* **Crashing**, quickly approach vehicle and inspect battery for **visible damage**
  - **Check the temperature** of the battery, **heat indicated an internal short**
  - Internal short: Battery builds up heat, and could "go off" (can happen within seconds, or after several minutes)
  - Remove the Lipo from the vehicle if not to hot
  - Pick up by the wires and put battery at the ground were it safely can burn down
  - LiPo batteries are non-toxic, and can be disposed in thrash after burn-out
* **"Go off"**, burn-out
  - In multi cell LiPos each cell can **go off separately**
  - Cell **expands, eventually breaks** (pops)
  - **Very hot smoke** streams out of a broken cell, **may lit on fire**

### Disposal

* Many hobby shops properly dispose LiPo batteries
* Fully discharge to 0V (zero volts)
  - Use a discharging device, e.g. light bulbs
  - Discharge on a small current e.g. 1/10C
  - During the process heat is generated
  - Potential for swelling, even fire is possible
  - Submerge battery in a bucket of sand during full discharge
* Check for 0V before cutting the connector, and twisting the wires
