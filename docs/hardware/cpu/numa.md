**Non-Uniform Memory Access** (NUMA)

* Multiple processors, collectively called **node** (aka cell, zone), are physically grouped on a socket.
* Each node has high speed access to a local **dedicated memory bank**.
* An **interconnect bus** provides connections between nodes, so that all CPUs can still access all memory
* There is a **performance penalty for processors accessing non-local memory**.
* `/sys/devices/system/node` contains information about NUMA nodes in the system, and the relative distances between those nodes

```bash
yum install -y hwloc numactl
numactl --hardware               # examine the NUMA layout 
lstopo                           # show memory and CPU topology
```
