# Motherboard

Main circuit board to connect different build components of a computer.

* Also known as mainboard, system board, abbreviated to MB
* System Clock (CMOS Battery)
* Front Panel, connectors for external devices (i.e. USB, HDMI, Audio)
* **BIOS** (Basic Input/Output System)
  - Performs hardware check after power on
  - Configurable with a system settings menu (boot devices, power settings, etc.)
* **Chipset**
  - Determines which components are compatible 
  - Dictates future expansion options
  - Enables overclocking of CPUs, RAM
  - Single-chip on modern systems directly connected to the CPU 
  - Intel Platform Controller Hub (PCH), Direct Media Interface (DIM)
  - AMD Fusion Controller Hub (FCH), Unified Media Interface (UMI)
* **VRM** (Voltage Regulator Module)
  - Senses the CPU voltage requirements
* SATA storage controller


Following a couple of introduction material on Youtube:

* [Motherboards Explained][mb2]
* [Understanding Motherboard Anatomy For Beginners][mb1]
* [Components Of The Motherboards][mb3]
* [PC Motherboard Sizes as Fast As Possible][mb4]
* [Which Motherboard Should You Buy?][mb5]
* [How to Choose a Motherboard: 3 Levels of Skill][mb6]
* [Motherboard Connectors - All you Need to Know as Fast As Possible][mb7]

Manufacturers:

* [ASUS][mf1]
* [Gigabyte][mf2]
* [ASRock][mf3]
* MSI
* Intel
* EVGA
* Acer
* Sapphire Technology
* XFX

## Form Factor

Size of the motherboard:

* **ATX**, 305x244mm
  - Full/Mid tower cases
  - Most common, de facto standard
  - Up to 7 expansion slots
  - Up to 8 memory slots
* **Micro-ATX** 244x244mm
  - Less expensive
  - Max. 4 expansion slots
  - 2-4 memory slots
* **Mini-ITX** 170x170mm
  - Even less expensive
  - 1 expansion slot
  - Up to 2 memory slots

## Connectors

Main power connection

* **ATX 24** pin 12V (ATX v2.2 standard)
  - Connects the board to the PCU (Power Supply Unit)
  - Molex 39-01-2240, often called a Molex Mini-fit Jr.
  - ATX 20+4 for backwards compatability
* **ATX/EPS** 8 pin 12V (EPS12V)
  - Powers the processor voltage regulator
  - Dedicated CPU power supply
  - Molex 39-28-1083
  - Not to confuse with 8 pin PCIe connectors
* **P4** 4 pin ATX 12V 
  - Additional power connector on older boards
  - Molex 39-28-1043

* CPU Socket
* Memory Slots
* Expansion Slots
* Storage Connectors (SATA ports, M.2)
* I/O Interfaces (on board)
* Front panel connectors
  - USB 2 8 pin
  - USB 3
  - Audio connector
* 3/4 pin fan connectors (4 pin is backwards compatible to accommodate 3 pins)
* RGB Connection

## CPU Socket & Chipset

**Motherboards need to match/support the CPU!**

Following a couple of introduction material on Youtube:

* [An Introduction to Computer Chipsets][cs1] (2018)

Selection of chipset is relevant to overclocking and customization.

List of current sockets with corresponding chipset and CPU compatibility:

### AMD

CPU generations

- Ryzen 1000 series (1st)
- Ryzen 2000 series (2nd)
- Ryzen 3000 series (2rd)
- Ryzon 4000 series (4th), Zen 3

Socket **AM4**

- Chipset 300-series, 1st,2nd,3rd Gen CPUs
- Chipset 400-series, 1st,2nd,3rd Gen CPUs
- Chipset 500-series, 2nd,3rd,4th Gen CPUs

Chipset classes, X & B support overclocking

* Premium X{3,4,5}70
* Midrange B{3,4,5}50
* A{3,4,5}20

[AMD Socket AM4 Platform][cs3] list all chipsets

Following a couple of introduction material on Youtube:

* [AMD Chipset Differences: B550 Specs Explained vs. X570, B450, & Zen 3
Support][cs4] (2020)

### Intel

Socket LGA 1151

- Chipset 100 or 200-series for 6th/7th Gen CPUs (6700k,7700k)
- Chipset 300-series for 8th & 9th Gen CPUs (8700k,9900k)

Socket LGA 1200

- Chipset 400-series for 10th Gen CPUs (10900k)

List of [Intel Desktop Chipsets][cs2]

## Expansion Slots

**Expansion slots need to support the expansion card!**

Following a couple of introduction material on Youtube:

* [Explaining PCIe Slots][es1]
* [PCI Express (PCIe) 3.0 - Everything you Need to Know As Fast As
  Possible][es2]
* [PCI Express 4.0 as Fast As Possible][es3] (2018)

Motherboards support PCI Express (PCIe) slots:

* **PCIe x16** (de facto standard for video cards, GPUs)
* **PCIe x1** (network, audio, I/O interfaces)
* Replaces PCI, and AGP

`x{1,4,8,16}` indicates the number of parallel lanes.

Slots are downwards compatible (physical protection for wrong slotting)

**GPU expansion cards need to match the PCI generation for max. performance.**

PCIe generations:

Year  | Version | Speed (per lane)
------|---------|-----------------
2010  | **3.0** | 985MB/s
2017  | **4.0** | 1.97GB/s


## I/O Interfaces

Connectivity varies widely on motherboards, and have a huge impact on prices.

Located on the rear (or back) I/O panel, and on the motherboard surface

- **USB** for mouse, keyboard, microphones, cameras, storage, etc
- **NIC** typically Ethernet
- **Sound** input/output for headphones, and a microphone
- Some motherboards support integrated video (DisplayPort, HDMI)
- Some motherboards include Wifi, and Bluetooth

[cs1]: https://www.youtube.com/watch?v=5mCJ3uGNTAw
[cs2]: https://www.intel.com/content/www/us/en/products/chipsets/desktop-chipsets.html
[cs3]: https://www.amd.com/en/products/chipsets-am4
[cs4]: https://www.youtube.com/watch?v=qfTPLF8OKK4
[es1]: https://www.youtube.com/watch?v=PrXwe21biJo
[es2]: https://www.youtube.com/watch?v=LSSHuMHbCWo
[es3]: https://www.youtube.com/watch?v=aXMJeozEl4A
[mb1]: https://www.youtube.com/watch?v=Cs8I4-jmUJw
[mb2]: https://www.youtube.com/watch?v=b2pd3Y6aBag
[mb3]: https://www.youtube.com/watch?v=PAqB2cb5hSg
[mb4]: https://www.youtube.com/watch?v=Tbeh1eRDmsk
[mb5]: https://www.youtube.com/watch?v=0xZc7YryJ0U
[mb6]: https://www.youtube.com/watch?v=lP-pinlU-Ko
[mb7]: https://www.youtube.com/watch?v=csqnK_CwKrQ

[mf1]: https://www.asus.com/Motherboards
[mf2]: https://www.gigabyte.com/Motherboard
[mf3]: https://www.asrock.com/mb/index.asp
