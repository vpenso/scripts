
# Memory

Physical device (integrated circuit) that stores information (code/data) temporary/permanent:

* Temporary **volatile** memory requires power to maintain stored data
* Non-volatile **persistent** storage retains stored data after power off

Concepts used to build memory systems a major factor in determining performance of a computer:

* Programs exhibit **temporal locality** (tendency to reuse data accessed recently) 
  and **spatial locality** (tendency to reference data close to recently used data)
* Memory hierarchies take advantage of temporal/spatial locality while moving data
  between fast/small **upper level** memory and big/slow **lower level** memory

## Hierarchy

A memory hierarchy separates storage into a layers/levels based on **latency** 
(response time) and **capacity**:

* Fast and large storage can not be achieved with a single level memory
* Multiple levels of storage progressively bigger and slower

Typical modern memory(/cache) hierarchy:

```
Name      | Latency | Size
----------|---------|----------------
Register  | <1ns    | B
L1 cache  | ~1ns    | ~32KB
L2 cache  | >1ns    | <1MB
L3 cache  | >10ns   | >1MB
DRAM      | ~100ns  | GB
Swap      | ~10ms   | TB
```

As distance to the processor increases, memory size and access time increases

* Internal processor **registers** ➜ integrated (small & fast) memory
  - Registers are read/written by machine instructions
  - Categories: **state-**, **address-**, and **data-registers**
* Volatile primary storage:
  - Processor **cache memory** is an intermediate stage between fast registers and (slower & bigger) main memory 
  - Volatile **main memory** operating at high speed compared to secondary storage
* Persistent secondary storage:
  - **Mass storage** devices like hard disk drives and rotating optical storage (CD/DVD)
  - **Flash memory** like USB flash drives and solid-state drives (SSD)

## Addresses

* **Memory cell** (electronic circuit) ➜ store one bit of binary data
* **Memory address** ➜ reference to a specific memory location
  - Usually several memory cells share a single address (e.g. 8bits/1byte)
  - The **address width** limits the maximum addressable memory
  - The address width is typically a multiple of eight (8,16,32,64 bits)

```
Address width | Address locations
--------------|------------------
8bit          | 256 (2^8)
16bit         | 65536 (2^16)
32bit         | 4294967296 (2^32)
64bit         | 1.844674407×10^19 (2^64)
```

* Memory is a collection of various **memory locations**
  - Each location has a **unique address** which can be accessed in any order (in equal amount of time)
  - Memory **access** means selection and data read/write from a specific memory location
* **Memory controller** ➜ manages data flow (read/write) between main memory and processor
* Memory **address bus** ➜ connects the main memory to the memory controller

Programmers see **virtual memory** provided by the system (OS + hardware):

* Simplified abstraction of memory for the program providing the illusion of "infinite" memory
* The system manages the physical memory space transparent to the programmer by mapping virtual memory addresses to the limited physical memory
* Example for the programmer/(micro) architecture trade-off

## Cache

**CPU Cache** is used to avoid repeated access to main memory (typically DRAM):

* Automatically managed memory hierarchy (Level 1,2,3) (typically SRAM) 
* Stores frequently used data and is commonly on-die with an associated CPU 

**Locality** ensures that data required by the processor is kept in the fast(er) level(s):

* Idea: Store recently accessed and adjacent data automatically in fast memory (RAM and cache)
* Temporal locality is based on repetitive computations (e.g. loops) referencing the same memory
* Spatial locality is based on a probability of related computations referencing a cluster of memory (e.g. array)

Memory is logically divided into fixed-size **blocks**. A block (or line) is the 
**minimum unit of information** either present or net present in a cache:

* Each block maps to a **location in the cache**, determined by the **index bits** in the address
* Cache **hit** - Use cached data instead if accessing next level memory
* Cache **miss** - Data not cached, read block from next level memory
* **Hit ratio**/rate - Percentage of accesses that result in cache hits
* **Miss rate** - (1-hit rate) Fraction of memory accesses not found
* Hit time - Time to access a level of the memory hierarchy (includes time to determine hit/miss)
* Miss penalty - Time to replace a block in the upper level with a block from the lower level
* **Average Memory Access Time** (AMAT) - Metric to analyze memory system performance

### Associativity

Caches fall into three categories: 

* **Direct-mapped** 
  - Each memory location maps into one and only one cache block
  - Fast, simple, inefficient
  - Maximum cache misses
* **Fully associative**
  - Any memory location can map to anywhere in the cache
  - Slow, complex, efficient
  - Perfect replacement policy (no cache misses)
* N-way **set associative**
  - Groups of blocks "sets" from associative pools
  - A compromise between simplicity and efficiency
  - Reduces cache misses

Types of cache misses:

* **Compulsory** (start miss): First access to a block, must be brought into the cache
* **Capacity**: Blocks are being discarded to free space
* **Conflict** (collision/interference miss): Occurs when several memory locations are mapped to the same cache block 

**Replacement policy**: Heuristic used to select the entry to replaced by uncached data (LRU (Least Recently Used))


## Technology

**Volatile Memory**:

* **SRAM** (Static Random Access Memory) - Two cross coupled inverters store a bit persistent (while powered)
  - Faster access (no capacitor), no refresh needed, access time close to cycle time
  - Lower density (6-8 transistors per bit), higher cost
  - Minimal power to retain charge in standby mode
  - Manufacturing compatible with logic process, typically integrated with the processor chip
* **DRAM** (Dynamic Random Access Memory) - Capacitor charge state indicates stored value, cells lose charge over time requiring a refresh
  - Slower access (capacitor)
  - Higher density (1 transistor + 1 capacitor per bit), lower cost
  - Requires periodic refresh (read + write), (costs power, performance, circuitry)
  - Manufacturing requires capacitors and logic
* **SDRAM** (Synchronous DRAM) - Uses a clock to eliminate the time memory and processor need to synchronize
  - Bandwidth improved by internal organization into multiple **banks** each with its own row buffer
  - Banks allow simultaneous read/write calle **address interleaving**
  - Fastest version called **DDR** (Double Data Rare SDRAM), data transfer at rising & falling edges of the clock

**Persistent Memory** (PM pr _pmem_), aka **SCM** (Storage Class Memory):

* Bridge the access-time gap between DRAM and NAND based flash-storage 
  in the memory hierarchy, introducing a **third tier**:
  - Connected to the system memory bus (like DRAM DIMMs) via **NVDIMMs**
  - Accessed like volatile memory (processor load/store instructions)
* Enables a change in computing architecture, since software is no longer 
  bound by file-system overhead to run persistent transactions

```
Access time  | Description
-------------|---------------------------------
1ns          | processor operation
<5ns         | read L2 cache
60ns         | access memory (DRAM)
<1us         | access persistant memory (to overcome access time gap
20us         | read from flash memory (NAND)
1ms          | random write to flash memory
5ms          | read/write disk
40s          | read tape
```

* Requires an [NVM Programming Model][pmem]
  - New block and file semantics to applications
  - Exposed as memory-mapped file by the operating system
* Persistent memory aware file-system allows **DAX** (Direct Access) without 
  using (bypass) the system page cache (unlike normal storage-based files)
  - Application has direct load/store access to persistence via the MMU
  - No interrupts or kernel context switches
  - OS (only) flushs CPU caches to get data into the persistence domain

Non-Volatile Memory (NVM), **NVRAM** - Retains its information when power is turned off

* **RRAM**/ReRAM (Resistive Random-Access Memory) - Uses a dielectric solid-state material aka memristor
  - In development by multiple companies...
  - Scalable below 30nm, cycle time <10ns
* Alternatives...
  - CBRAM (Conductive-Bridging RAM)
  - PCM (Phase-Change Memory), aka PCRAM
  - MRAM (Magnetoresistive RAM)
  - FeRAM (Ferroelectric RAM)
* 3D XPoint (Intel, Micron)

### Memory Modules

Memory for servers commonly sold in small boards called **DIMM** (Dual Inline Memory Module):

* Typically contains 4-16 DRAMs chips, normally organized to be 8 bytes wide
* Variants of DIMM slots (i.e. DDR3 or DDR4) have **different pin counts**
* **ECC** (Error-Correcting code) DIMMs have extra circuitry to detect/correct errors

Following a list of common DIMM chips:

```
 Standard     |  Chip       | Throughput
--------------|-------------|-------------
 SDRAM (1993) | SDR-66      | 533MB/s
              | SDR-133     | 800MB/s
 DDR (1996)   | DDR-200     | 1.6GB/s
              | DDR-266     | 2.13GB/s
 DDR2 (2003)  | DDR2-400    | 3.2GB/s
              | DDR2-800    | 6.4GB/s
 DDR3 (2007)  | DDR3-1600   | 12.8GB/s
              | DDR3-1866   | 14.93GB/s
 DDR4 (2012)  | DDR4-2133   | 17GB/s
              | DDR4-3200   | 24GB/s
 DDR5 (2018)  | 
```

Display the memory **vendor, identification numbers, and type** with `dmidecode`:

    » dmidecode --type memory | egrep "Manufacturer|Serial|Part|Type" 
            Error Correction Type: Multi-bit ECC
            Type: DDR3
            Type Detail: Synchronous Registered (Buffered)
            Manufacturer: Samsung    
            Serial Number: 35244B2E
            Part Number: M393B2G70BH0-YK0  
    […]

### Module Distribution

Maximum RAM capacity can be checked with `dmidecode`. The "Maximum Capacity" is the maximum RAM supported by your system, while "Number of Devices" is the number of memory (DIMM) slots available on your computer.

    » dmidecode -t 16 | egrep "Capacity|Devices"
            Maximum Capacity: 384 GB
            Number Of Devices: 32

Check the memory support matrix for the system board to understand the **correct DIMM distribution** and their corresponding memory frequencies. 

### Frequency & Voltage

Check the memory speed with [lshw](http://manpages.debian.org/lshw) (package [lshw](https://packages.debian.org/lshw)): 

    » lshw -short -C memory | grep DIMM
    /0/1b/0                     memory     16GiB DIMM DDR3 Synchronous 800 MHz (1.2 ns)
    […]

Details about voltage and maximum memory frequency with `decode-dimms` from the Debian package _i2c-tools_:

    » modprobe eeprom
    » decode-dimms
    […]
    Fundamental Memory type                         DDR3 SDRAM
    Module Type                                     RDIMM
    […]
    Maximum module speed                            1600MHz (PC3-12800)
    Size                                            16384 MB
    […]
    Operable voltages                               1.5V, 1.35V

### Cache Layers

Display the cache/memory hierarchy with `lshw`:

    » lshw -C memory -short
    H/W path           Device      Class       Description
    ======================================================
    /0/0                           memory      64KiB BIOS
    /0/400/700                     memory      256KiB L1 cache
    /0/400/701                     memory      1MiB L2 cache
    /0/400/704                     memory      8MiB L3 cache
    /0/1000                        memory      12GiB System Memory
    /0/1000/0                      memory      4GiB DIMM DDR3 1066 MHz (0.9 ns)
    /0/1000/1                      memory      4GiB DIMM DDR3 1066 MHz (0.9 ns)
    /0/1000/2                      memory      4GiB DIMM DDR3 1066 MHz (0.9 ns)
    /0/1000/3                      memory      DIMM DDR3 Synchronous [empty]
    /0/1000/4                      memory      DIMM DDR3 Synchronous [empty]
    /0/1000/5                      memory      DIMM DDR3 Synchronous [empty]

[pmem]: https://docs.pmem.io/
