## Flash File-System

SD cards almost always pre-formatted, typically FAT32 of exFAT (on SDXC cards)

* Most controllers optimises for FAT
* First partition starts on an erase boundary (segment-aligned)

Potential file-systems to use on MMC devices

* **FAT** (default on SD cards)
  - Lacks features of modern file-systems 
* **F2FS** (Flash Friendly File-System)
  - Create by Samsung, integrated into the Linux kernel (2013)
  - Aims to create a NAND flash aware file-system
  - Atomic operations, defragmentation, TRIM support

Supported in Linux though the mmc subsystem

* Code located in `drivers/mmc` and headers in `include/linux/mmc/`
* Block device `/dev/mmc*`

