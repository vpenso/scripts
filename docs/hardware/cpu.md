
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
