
```bash
lscpu                            # display CPU architecture and support flags
inxi -C                          # display CPU Type, clock speed and cache size
```

### Topology

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

### Frequency Scaling

→ [Linux CPUFreq Governors](https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt)

**Dynamic Frequency Scaling** (aka CPU throttling)

* CPU support: Intel SpeedStep, AMD Cool’n’Quiet
* Note that firmware may configure frequency and thermal management 
* Lower clock speed results in a slower CPU consuming less energy 
* Frequency **scaling governors** in the kernel support:
  * CPU frequency/voltage mappings
  * Upper/lower frequency limits
  * Strategies to switch between mappings

```bash
watch grep \"cpu MHz\" /proc/cpuinfo                         # monitor cpu speed
cpupower frequency-info                                      # show throttling configuration
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor    # current power scheme for the CPU
cpupower frequency-set -g <governor>                         # activate a particular power scheme
cpufreq-info                                                 # show throttling configuration
/etc/default/cpufrequtils                                    # power sheme configuration
### depricated with linux kernel <2.3.36
grep throttling /proc/acpi/processor/CPU*/info               # show state of throttling control
grep -e ^active -e \*T /proc/acpi/processor/CPU*/throttling  # active configuration if enabled
```
