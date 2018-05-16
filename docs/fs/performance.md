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

**iostat**, I/O statistics for partitions. Option `-k` prints values in kilobytes.

    » iostat -xk 1  | awk '/sda/ {print $6,$7}'                  
    14.36 162.23
    0.00 9144.00
    0.00 3028.00
    […]

**iotop**, list of processes/threads consuming IO bandwidth. In interactive mode use the arrow keys to select the column used for sorting. "o" limits the view to active processes, and "a" accumulates the I/O counters.

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

**pidstat**, I/O statistics for executables:

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
