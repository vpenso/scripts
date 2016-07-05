
# Memory

Following a list of common DIMM modules:

| Standard     |  TYPE       | Throughput  |
|--------------|-------------|-------------|
| SDRAM (1993) | PC-66       | 533MB/s     |
|              | PC-133      | 800MB/s     |
| DDR (1996)   | DDR-200     | 1.6GB/s     |
|              | DDR-266     | 2.13GB/s    |
| DDR2 (2003)  | DDR2-400    | 3.2GB/s     |
|              | DDR2-800    | 6.4GB/s     |
| DDR3 (2007)  | DDR3-1600   | 12.8GB/s    |
|              | DDR3-1866   | 14.93GB/s   |
| DDR4 (2012)  | DDR4-2133   | 17GB/s      |
|              | DDR4-3000   | 24GB/s      |

Display the memory **vendor, identification numbers, and type** with `dmidecode`:

    » dmidecode --type memory | egrep "Manufacturer|Serial|Part|Type" 
            Error Correction Type: Multi-bit ECC
            Type: DDR3
            Type Detail: Synchronous Registered (Buffered)
            Manufacturer: Samsung    
            Serial Number: 35244B2E
            Part Number: M393B2G70BH0-YK0  
    […]

## Module Distribution

Maximum RAM capacity can be checked with `dmidecode`. The "Maximum Capacity" is the maximum RAM supported by your system, while "Number of Devices" is the number of memory (DIMM) slots available on your computer.

    » dmidecode -t 16 | egrep "Capacity|Devices"
            Maximum Capacity: 384 GB
            Number Of Devices: 32

Check the memory support matrix for the system board to understand the **correct DIMM distribution** and their corresponding memory frequencies. 

## Frequency & Voltage

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

## Cache Layers

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

