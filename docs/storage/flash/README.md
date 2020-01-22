# Flash

Generally come in two flavors:

* NOR 
  - Used to store firmware images on embedded devices
  - Connected to the processor via address and data lines (like RAM)
  - Can be eXecuted In Place (XIP) by a processor
* NAND
  - Used for solid-state mass storage media (USB sticks, SD cards)
  - Large, dense, cheap, but imperfect storage
  - Interfaces uses IO and control lines
  - Has to be copied to RAM before execution
  - Requires some sort of flash memory management

NAND typically presented to the system as ATA disk

* **FTL** (Flash Translation Layer)
  - Handle all internal flash memory operations
  - Presents illusion of ‘standard’ block device
  - Logical to physical address mapping
  - Block size translation
  - Power off recovery
  - Wear leveling (erase/write counts)
  - Error correction (single/multi bit errors)
  - Bad-block management (remap failing blocks)
  - Write RAM buffer (tends to scale with price/size)
* Typically embedded in hardware (categorized as managed NAND)

NAND characteristics:

* Erased in blocks at a time, before re-write is possible
* Erase blocks are divided into pages (for example 64 per erase block)
* Pages usually a multiple of 512 bytes
* "Spare area" bytes used to store meta data (i.e. worn out marker, ECC data)
* Usually has bad blocks already when leaving the factory (to save costs)

Flash memory is **unreliable**:

* Data stored as probabilistic approximations
* Workaround: computational error correction (ECC)

Contain an internal controller:


## Standards

**MMC** (MultiMedia Card)

* Non-volatile, removable, portable flash (NAND) base storage
* Developed by Joint Electron Device Engineering Council (JEDEC)
* SD (Secure digital) cards are an improvement to MMC

**eMMC** (Embedded MultiMedia Card)

* **Not removable**
* Optimized for low cost, low power, small form factor
* Typically single silicon dye for controller, interface, and memory

**UFS** (Universal Flash Storage)

* Meant to replace SC cards and eMMCs


