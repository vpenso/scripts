

**lfs** monitoring and configuration:

```bash
findmnt -t lustre --df                 # list Lustre file-systems with mount point
lfs help                               # list available options
lfs help <option>                      # show option specific information
lfs osts                               # list vailable OSTs
lfs osts | tail -n1 | cut -d: -f1      # number of OSTs
lfs df -h [<path>]                     # storage space per OST
lfs quota -h -u $USER [<path>]         # storage quota for a user
lfs find -print -type f <path>         # find files in a directory
```

Identify storage topology (cf. [clush.md](clust.md)):

```bash
# get a list of all storage servers
>>> lctl get_param osc.*.ost_conn_uuid | ip2host | cut -d= -f2 | cut -d@ -f1 | cut -d. -f1 | sort | uniq | nodeset -f NS
lxfs[415-419]
# list OSTs per storage server
>>> nodeset-loop "echo -n '{} ' ; lctl get_param osc.*.ost_conn_uuid | ip2host | grep {} | cut -d'-' -f2 | tr '\n' ' '"
lxfs415 OST001c OST001d OST001e OST001f OST0020 OST0021 OST0022
lxfs416 OST0015 OST0016 OST0017 OST0018 OST0019 OST001a OST001b
lxfs417 OST000e OST000f OST0010 OST0011 OST0012 OST0013 OST0014
lxfs418 OST0007 OST0008 OST0009 OST000a OST000b OST000c OST000d
lxfs419 OST0000 OST0001 OST0002 OST0003 OST0004 OST0005 OST0006
```

[Sybsystem Map](http://wiki.lustre.org/Subsystem_Map)

# IO

Quantitative description of application IO from the perspective of the file-system:

1. The size of data generated
2. The number of files generated
3. The distribution of file sizes
4. The distributions of file IOs (requests sizes, frequency)
5. The number of simulations IO accesses (level of concurrency)

## Profile

IO requests/-sizes:

```bash
# enable (reset) client IO statistics
>>> lctl set_param llite.*.extents_stats=1
# ... execute application ...
>>> dd if=/dev/zero of=io1.sink count=1024 bs=1M
>>> dd if=/dev/zero of=io2.sink count=1024 bs=128k
>>> dd if=/dev/zero of=io3.sink count=1024 bs=32k
# read the stats for the client
>>> lctl get_param llite.*.extents_stats
                               read       |                write
      extents            calls    % cum%  |          calls    % cum%
  32K -   64K :              0    0    0  |           1024   33   33
 128K -  256K :              0    0    0  |           1024   33   66
   1M -    2M :              0    0    0  |           1024   33  100
# read stats by process ID
>>> lctl get_param llite.*.extents_stats_per_process
                               read       |                write
      extents            calls    % cum%  |          calls    % cum%
PID: 27280
   1M -    2M :              0    0    0  |           1024  100  100
PID: 27344
 128K -  256K :              0    0    0  |           1024  100  100
PID: 27348
  32K -   64K :              0    0    0  |           1024  100  100
```

RPC statistics:

```bash
>>> lctl set_param osc.*.rpc_stats=0 # reset the RPC counters
# monitor IO aggregation by Lustre
>>> lctl get_param osc.*.rpc_stats
                        read                    write
pages per rpc         rpcs   % cum % |       rpcs   % cum %
1024:                    0   0   0   |       1276  99 100
```

## Striping

Split a file into small sections (stripes) and distribute these for concurrent access to multiple OSTs.

* Advantages:
  - The **file size** can be bigger then the storage capacity of a single OST.
  - Enables to utilize the **I/O bandwidth** of multiple OSTs while accessing a single file.
* Disadvantages:
  - Placing stripes of a file across multiple OSTs requires a **management overhead**. (Hence small files should not be striped)
  - A higher number of OSTs holding stripes of a file increases the **risk to losing access** as soon as a single OST is unreachable. 

```bash
lfs getstripe <file|dir>                    # show striping information
lfs setstripe -c <stripe_count> <file|dir>  # configure the stripe count  
lfs setstripe -i 0x<idx> <file|dir>         # target a specific OST
```

* File inherit the striping configuration of their parent directory.
* **Stipe Count** (default 1)
  - By default a single file is stored to a single OST.
  - A count of `-1` stripes across all available OSTs (eventually used for very big files).
* **Stripe Size** (default 1MB)
  - Maximum size of the individual stripes.
  - Lustre sends data in 1MB chunks → stripe size are recommended to range between 1MB up to 4MB

### Alignment

Application I/O performance is influenced by choosing the right file size and stripe count.

Correct I/O alignment mitigates the effects of:

* **Resource contention** on the OST block device.
* **Request contention** on the OSS hosting multiple OSTs.

General recommendations for stripe alignment:

* Minimize the number of OSTs a process/task must communicate with.
* Ensure that a process/task accesses a file at offsets corresponding to stripe boundaries.

