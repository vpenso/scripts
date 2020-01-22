SD Card (Secure Digital Card)

* **Non-volatile memory** for consumer hand-held and portable electronics
* Developed as with compatible to Multi Media Card (MMC)
* SD Specifications is controlled by the [SD Card Association](https://www.sdcard.org/)

Flash memory is **unreliable**:

* Data stored as probabilistic approximations
* Workaround: computational error correction (ECC)

Contain an internal controller:

* Handle all internal flash memory operations
* Presents illusion of ‘standard’ block device
* Wear leveling translation (~100k erase cycles limits life time)
* Error correction (single/multi bit errors)
* Bad-block management (remap failing blocks)
* Block size translation
* Write RAM buffer (tends to scale with price/size)



## Hardware

Dimensions: 

* Standard 32x24mm (2g)
* Mini 21x20mm (800mg)
* Micro 15x11mm (250mg)

Families| Size           | Description
--------|----------------|--------------------
SDSC    | 1 MB to 2 GB   | Standard-Capacity
SDHC    | 2 GB to 32 GB  | High-Capacity
SDXC    | 32 GB to 2 TB  | eXtended-Capacity
SDUC    | 2 TB to 128 TB | Ultra-Capacity 

Bus      | Speed max.  | Spec 
---------|-------------|-------
UHS-I    | ≤ 104MB/s   | 3.01
UHS-II   | ≤ 312MB/s   | 4.0
UHS-III  | ≤ 624MB/s   | 6.0
Express  | ≤ 985MB/s   | 7.0

Speed **classes**: U1,U3 (10/30 MB/s) - V{1,3,6,9}0 MB/s

Vendors:

* [SanDisk][sdi]
* [Samsung][sam]
* [Lexar][lex]
* [Kingston][king]
* [Toshiba][tosh]

Model                  | Read MB/s | Write MB/s | Size GB
-----------------------|-----------|------------|----------------
SanDisk Extrem PRO     | <275      | <100       |       64,128
Lexar 1800x            | <270      | <150       |       64,128
Toshiba M502           | <270      | <150       | 16,32,64
SanDisk Extrem PLUS    | <170      | <90        |    32,64,128,256,400,512
SanDisk Extrem         | <160      | <90        |    32,64,128,256,400,512
Lexar 1000x            | <150      | <90        |    32,64,128,256
Samsung EVO Plus       | <100      | <90        |    32,64,128,256,512
Samsung EVO Select     | <100      | <90        |    32,64,128,256,512
Kingston Canvas React  | <100      | <80        |    32,64,128,256,512
Lexar 633x             | <100      | <70        | 16,32,64,128,256,512
Samsung PRO Endurance  | <100      | <30        |    32,64,128
SanDisk Ultra PLUS     | <100      |            | 16,32,64,128,256,512
Samsung EVO            | <100      |            |    32,64,128,256
Toshiba M402           | <95       | <95        | 16,32,64,128
Toshiba M401           | <95       | <80        | 16,32,64
Toshiba M303           | <95       | <65        |       64,128,256
Toshiba M302           | <90       |            | 16,32,64,128
Kingston Canvas Go     | <90       | <45        |    32,64,128
SanDisk Ultra          | <80       |            | 16,32,64
Kingston Canvas Select | <80       | <10        | 16,32,64,128,256
Lexar 300x             | <45       | <45        | 16,32,65

[king]: https://www.kingston.com/us/flash/microsd_cards
[lex]: https://www.lexar.com/products/memory-cards/
[sam]: https://www.samsung.com/us/computing/memory-storage/memory-cards
[sdi]: https://www.sandisk.com/home/memory-cards
[tosh]: https://www.toshiba-memory.com/product-category/micro-sd-cards

## File-system

Almost always pre-formatted, typically FAT32 of exFAT (on SDXC cards)

* Controller optimises for FAT fs
* First partition starts on an erase boundary (segment-aligned)

Supported in Linux though the mmc subsystem

* Code located in `drivers/mmc` and headers in `include/linux/mmc/`

## References

[sdchk] SD Card Hacking  
https://bunniefoo.com/bunnie/sdcard-30c3-pub.pdf

[flsbn] Flashbench  
https://github.com/bradfa/flashbench

[olcfd] Optimizing Linux with cheap flash drives  
https://lwn.net/Articles/428584/
