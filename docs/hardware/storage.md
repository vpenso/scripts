
    hwinfo --disk
    lshw -class storage -class disk --class volume
    fdisk -l
    hdparm -I /dev/sda
    smartctl -a /dev/sda
    /proc/partitions
    parted -l | grep '^Disk /dev'

# Controllers


| Year | Interconnect    | Throughput |
|------|-----------------|------------|
| 1986 | IDE (ATA)       |            |
|      | SCSI 1          | 5MB/s      |
| 1994 | EIDE (ATA 2)    | 8.3MB/s    |
|      | ATA 6           | 100MB/s    |
| 2003 | SATA 1(.5)      | 150MB/s    |
|      | SATA 2.0        | 280MB/s    |
|      | SAS 1.1         | 300MB/s    |
| 2008 | SATA 3.0        | 600MB/s    |
|      | SAS 2.1         | 600MB/s    |
|      | SCSI Ultra-5    | 640MB/s    |
|      | SAS 3.0         | 1.2GB/s    |
| 2013 | SATA 3.2        | 1.9GB/s    |

IDE/EIDE compatible interfaces are called PATA on modern controllers.

List storage device controllers with <kbd>lspci</kbd>:

    » lspci | egrep "RAID|SATA"
    00:1f.2 SATA controller: Intel Corporation Patsburg 6-Port SATA AHCI […]
    03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS TB (rev 05)
    04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS TB (rev 05)
    07:00.0 Serial Attached SCSI controller: Intel Corporation Patsburg 4-Port SATA […]

Get the ATA configuration from the boot messages:

    » dmesg | grep ata[0-9] | tr -s ' ' | cut -d' ' -f3- | sort
    ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
    ata1.00: ATA-8: TOSHIBA MK1002TSKB, MT4A, max UDMA/100
    ata1.00: configured for UDMA/100
    ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata1: SATA max UDMA/133 abar m1024@0xdfdfa400 port 0xdfdfa500 irq 22
    ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
    ata2.00: ATA-8: TOSHIBA MK1002TSKB, MT4A, max UDMA/100
    ata2.00: configured for UDMA/100
    ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    ata2: SATA max UDMA/133 abar m1024@0xdfdfa400 port 0xdfdfa580 irq 22
    ata3: SATA link down (SStatus 0 SControl 300)
    ata3: SATA max UDMA/133 abar m1024@0xdfdfa400 port 0xdfdfa600 irq 22
    ata4: SATA link down (SStatus 0 SControl 300)
    ata4: SATA max UDMA/133 abar m1024@0xdfdfa400 port 0xdfdfa680 irq 22
    ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x410 irq 14
    ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x418 irq 15

# Disks

List disk hardware with <kbd>lshw</kbd>:

    » lshw -class disk
      *-disk
           description: ATA Disk
           product: ST3250318AS
           vendor: Seagate
           […]
           logical name: /dev/sda
           […]
           size: 232GiB (250GB)
           […]
      *-cdrom
           description: DVD reader
           product: DVD-ROM DH30N
           vendor: HL-DT-ST
           […]
    » lshw -class tape -class disk -class storage -short
    H/W path         Device     Class      Description
    ==================================================
    /0/100/11        scsi0      storage    SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode]
    /0/100/11/0      /dev/sda   disk       1TB TOSHIBA MK1002TS
    /0/100/11/1      /dev/sdb   disk       1TB TOSHIBA MK1002TS
    /0/100/14.1                 storage    SB7x0/SB8x0/SB9x0 IDE Controller

Get SATA/IDE device parameters with <kbd>hdparm<kbd>:

    » hdparm -I /dev/sda
    […]
    Configuration:
            Logical         max     current
            cylinders       16383   16383
            heads           16      16
            sectors/track   63      63
            --
            CHS current addressable sectors:   16514064
            LBA    user addressable sectors:  268435455
            LBA48  user addressable sectors:  488281250
            Logical/Physical Sector size:           512 bytes
            device size with M = 1024*1024:      238418 MBytes
            device size with M = 1000*1000:      250000 MBytes (250 GB)
            cache/buffer size  = 8192 KBytes
            Nominal Media Rotation Rate: 7200
    […]

# Devices

Hard drives have an abstraction layer called **block device**. Blocks have a fixed **block size**. Each block can be accessed independently. 

| Device     | Description                      |
|------------|----------------------------------|
| `/dev/hd*` | IDE/ATA disk devices             |
| `/dev/sd*` | SCSI/SATA disk devices           |
| `/dev/sr*` | SCSI/SATA ROM drive              |

Disk device file names have the format `/dev/sd[a-h][0-8]`, where the letter is the physical drive, and the number the partition. "a" refers to the first disk, "b" to the second, and so forth. Read the **hd** and the **sd** man pages.

List available block devices with <kbd>lsblk</kbd> command:

    » lsblk
    NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sda      8:0    0 232.9G  0 disk 
    ├─sda1   8:1    0  18.6G  0 part /
    ├─sda2   8:2    0     1K  0 part 
    ├─sda3   8:3    0  11.2G  0 part [SWAP]
    ├─sda4   8:4    0 139.7G  0 part /srv
    ├─sda5   8:5    0  18.6G  0 part /tmp
    └─sda6   8:6    0  18.6G  0 part /var
    sr0     11:0    1  1024M  0 rom  
    » lsblk -o KNAME,TYPE,SIZE,MODEL
    KNAME TYPE   SIZE MODEL
    sda   disk   279G MR9271-4i
    sda1  part  64.3G 
    sda2  part     1K 
    sda5  part     2G 
    sda6  part  28.7G 
    sda7  part 183.9G 
    sdb   disk   2.2T MR9271-4i
    sdb1  part   2.2T 

List the block devices files in the `/dev/` directory: 

    » ls -l /dev/sd* | grep disk
    brw-rw---T 1 root disk   8,  0 Jul 31 10:44 /dev/sda
    brw-rw---T 1 root disk   8,  1 Jul 31 10:44 /dev/sda1
    brw-rw---T 1 root disk   8,  2 Jul 31 10:44 /dev/sda2
    brw-rw---T 1 root disk   8,  3 Jul 31 10:44 /dev/sda3
    brw-rw---T 1 root disk   8,  4 Jul 31 10:44 /dev/sda4
    brw-rw---T 1 root disk   8,  5 Jul 31 10:44 /dev/sda5
    brw-rw---T 1 root disk   8,  6 Jul 31 10:44 /dev/sda6

List block devices with major:minor device numbers in `/sys/dev/block/`.

Since block devices are detected by the kernel at boot the command `dmesg` provides information on their configuration:

    » dmesg | grep 'sd[a-z]' | tr -s ' ' | cut -d' ' -f3-       
    sd 0:0:0:0: [sda] 488281250 512-byte logical blocks: (250 GB/232 GiB)
    […]
    Adding 11718652k swap on /dev/sda3. Priority:-1 extents:1 across:11718652k 
    EXT4-fs (sda1): re-mounted. Opts: (null)
    EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
    EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
    EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
    EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)

List block device unique IDs with <kbd>blkid</kbd>:

    blkid | sort
    /dev/sda1: UUID="35c30dde-4956-4f0e-8abd-234df55d1385" TYPE="ext4" 
    /dev/sda3: UUID="044a4ae3-5037-48f9-8287-b104e5c23e82" TYPE="swap" 
    /dev/sda4: UUID="2f65f4b8-9402-4b88-8a3c-fc0ad73ea128" TYPE="ext4" 

## Write Protection

Use `hdparm` to control device write protection with option `-r 0|1`:

    » mount -o rw /dev/sdf1 /mnt
    mount: block device /dev/sdf1 is write-protected, mounting read-only
    […]
    » hdparm -r0 /dev/sdf1
    /dev/sdf1:
     setting readonly to 0 (off)
      readonly      =  0 (off)

# Partitions

List the partition tables with <kbd>parted</kbd>:

    » parted -l
    […]
    Disk /dev/sda: 250GB
    […]
    Number  Start   End     Size    Type      File system     Flags
     1      1049kB  20.0GB  20.0GB  primary   ext4            boot
     2      20.0GB  60.0GB  40.0GB  extended
     5      20.0GB  40.0GB  20.0GB  logical   ext4
     6      40.0GB  60.0GB  20.0GB  logical   ext4
     3      60.0GB  72.0GB  12.0GB  primary   linux-swap(v1)
     4      72.0GB  222GB   150GB   primary   ext4

List the partition table with <kbd>fdisk</kbd>:

    » fdisk -l | grep ^/dev
    /dev/sda1   *        2048    39063551    19530752   83  Linux
    /dev/sda2        39065598   117186559    39060481    5  Extended
    /dev/sda3       117186560   140623871    11718656   82  Linux swap / Solaris
    /dev/sda4       140623872   433592319   146484224   83  Linux
    /dev/sda5        39065600    78125055    19529728   83  Linux
    /dev/sda6        78127104   117186559    19529728   83  Linux

Similar information is available in `/proc/partitions` also. Use the `file` command to read the partition information form the device file.

    » file -s /dev/sda
    /dev/sda: sticky x86 boot sector; partition 1: ID=0x83, active, 
    starthead 32, startsector 2048, 39061504 sectors; partition 2: ID=0x5, 
    starthead 254, startsector 39065598, 78120962 sectors; partition 3: ID=0x82, 
    starthead 254, startsector 117186560, 23437312 sectors; partition 4: ID=0x83, 
    starthead 254, startsector 140623872, 292968448 sectors, code offset 0x63

# Performance

Performance Indicators:

* Throughput (Tp) – Volume of data processes within a specific time interval.
* Transactions (Tr) – I/O requests processed by the device in a specific time interval.
* Average Latency (Al) – Average time for processing a single I/O request.

Throughput and transaction rate are proportional (Block size (Bs))

    Tp [MB/s] = Tr [IO/s] × Bs [MB] 
    Tr [IO/s] = Tp [MB/s] ÷ Bs [MB]

Number of Worker Threads (Wt), Parallel I/Os (P)

    Al [ms] = 10³ × Wt × P ÷ Tr [IO/s]

Data transfered with is done in multiples of the block size. It is (usually) the unit of allocation on the device. 

## Throughput

The simples test is to write to the file-system with `dd`:

    » dd if=/dev/zero of=/tmp/output conv=fdatasync bs=384k count=1k; rm -f /tmp/output
    1024+0 records in
    1024+0 records out
    402653184 bytes (403 MB) copied, 4.28992 s, 93.9 MB/s
    » hdparm -Tt /dev/sda

    /dev/sda:
     Timing cached reads:   15852 MB in  2.00 seconds = 7934.52 MB/sec
     Timing buffered disk reads: 302 MB in  3.02 seconds = 100.10 MB/sec

Similarly `hdparm` can run a quit I/O test.

## Metrics

`/proc/diskstats`, I/O statistics of block devices. Each line contains the following 14 fields:

     1 - major number
     2 - minor mumber
     3 - device name
     4 - reads completed successfully
     5 - reads merged
     6 - sectors read
     7 - time spent reading (ms)
     8 - writes completed
     9 - writes merged
    10 - sectors written
    11 - time spent writing (ms)
    12 - I/Os currently in progress
    13 - time spent doing I/Os (ms)
    14 - weighted time spent doing I/Os (ms)

<kbd>iostat</kbd>, I/O statistics for partitions. Option `-k` prints values in kilobytes.

    » iostat -xk 1  | awk '/sda/ {print $6,$7}'                  
    14.36 162.23
    0.00 9144.00
    0.00 3028.00
    […]

<kbd>iotop</kbd>, list of processes/threads consuming IO bandwidth. In interactive mode use the arrow keys to select the column used for sorting. "o" limits the view to active processes, and "a" accumulates the I/O counters.

Limit output with option `-Po` for active processes only. Option `-a` accumulates I/O `-b` enables non-interactive batch mode:

    » iotop -bPao -u $USER 
    Total DISK READ:       0.00 B/s | Total DISK WRITE:       0.00 B/s
      PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
    25722 be/4 vpenso        0.00 B      8.14 M  0.00 %  0.00 % root.exe […]
    25728 be/4 vpenso        0.00 B      6.75 M  0.00 %  0.00 % root.exe […]
    25750 be/4 vpenso        0.00 B      8.00 K  0.00 %  0.00 % root.exe […]
    25739 be/4 vpenso        0.00 B      8.57 M  0.00 %  0.00 % root.exe […]
    […]

Option `-t` adds timestamps, and options `-q`, `-qq` prevent column headers. 

<kbd>pidstat</kbd>i, I/O statistics for executbales: 

    » pidstat -C "root.exe" -d -p ALL
    Linux 3.2.0-4-amd64 (lxdv111)   07/29/2014      _x86_64_        (8 CPU)

    05:09:42 PM       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
    05:09:42 PM     22587      0.25      0.04      0.00  root.exe
    05:09:42 PM     22592      0.27      0.04      0.00  root.exe
    05:09:42 PM     22597      0.22      0.04      0.00  root.exe
    05:09:42 PM     22605      0.32      0.04      0.00  root.exe
    05:09:42 PM     22609      0.32      0.04      0.00  root.exe
    05:09:42 PM     22615      0.27      0.04      0.00  root.exe
    05:09:42 PM     22623      0.29      0.04      0.00  root.exe
    05:09:42 PM     22628      0.12      0.04      0.00  root.exe


