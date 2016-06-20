
# Priorities

The [Multifactor Priority Plugin][01] enable administrators to influence the order of job allocation from the scheduling queue according to several configurable factors. Each factor with a weight bigger then zero contributes to the priority calculation:

```bash
>>> scontrol show config | grep ^PriorityWeight
[…]
>>> sprio -w
[…]
```

By default Slurm schedules jobs sequentially (FIFO). In order to **enable the use of multi-factor priorities** alter the `PriorityType` configuration to enable the plug-in:

```bash
>>> scontrol show config | grep -e ^PriorityType -e ^PriorityCalcPeriod                                    
PriorityCalcPeriod      = 00:05:00
PriorityType            = priority/multifactor
```

The option `PriorityCalcPeriod` configures the time **interval used to re-calculate all priorities**.

## Job Age

`PriorityWeightAge` increase a jobs priority depending on the length of time spend **waiting in the scheduler queue**. `PriorityMaxAge` defines the length of time until the age factor reaches is maximum multiplier of 1.0. 

```bash
>>> scontrol show config | grep -e ^PriorityWeightAge -e ^PriorityMaxAge
PriorityMaxAge          = 7-00:00:00
PriorityWeightAge       = 1000
```

## Job Size

`PriorityWeightJobSize` considers the **size of the requested job resources**. `PriorityFavorSmall` can be configured to favor larger jobs or smaller jobs. In addition the flag `SMALL_RELATIVE_TO_TIME` penalize requests for long run times. 

```bash
>>> scontrol show config | grep -e ^PriorityWeightJobSize -e PriorityFavorSmall -e ^PriorityFlags          
PriorityFavorSmall      = Yes
PriorityFlags           = […],SMALL_RELATIVE_TO_TIME
PriorityWeightJobSize   = 1000
```

## Partition Priority 

`PriorityWeightPartition` reflects **priorities assigned to each partition** individually. This allows to increase the priority of jobs fitting the resources provided by a specific partition.

```bash
PartitionName=main Nodes=lxbk00[0-63] Shared=NO Default=YES
PartitionName=long […] Priority=2 […]
PartitionName=highmen […] Priority=3 […]
```

## Trackable Resources

[Trackable RESources][tres] (TRES) are used to **monitor resource consumed by a job to be accounted and considered during the calculation of the fair share factor**. `AccountingStorageTRES` defines which consumable resources are tracked. By default CPU, Energy, Memory, and Node are tracked, whether specified or not. `PriorityWeightTRES` is a comma separated list of resource types and weights. It defines the degree how each resource contributes to the job's priority. `TRESBillingWeights` sets billing weights for each partition to configure how resources contribute to the calculation of a job resource consumption. 

Default configuration:

```bash
>>> scontrol show config | grep -e ^AccountingStorageTRES -e ^PriorityWeightTRES -e ^PriorityFlags -e TRESBillingWeights
AccountingStorageTRES   = cpu,mem,energy,node
PriorityFlags           = 
PriorityWeightTRES      = (null)
```

Custom configuration in [slurm.conf][slurmconf]:

```bash
AccountingStorageTRES=gres/gpu:tesla,license/iop1,bb/cray
PriorityFlags=[…],MAX_TRES
PriorityWeightTRES=CPU=1000,Mem=2000,GRES/gpu=3000
PartitionName=main […] TRESBillingWeights="CPU=1.0,Mem=0.25,GRES/gpu=2.0"
```

By default the sum of all tracked resources multiplied by their weight is calculated. This incorporates all resources into the aggregation of consumed resources. 

```bash
sum(<type>*<weight>,[…])
```

Alternatively the `MAX_TRES` flag alters the calculation to consider only the tracked resource with the biggest contribution to the resource consumption. 

```bash
max(<type>*<weight>,[…])
```

Basically the most expensive resource determines the cost of a job regards to its fair share factor.


## Fair Share

PriorityWeightFairShare defines the **weight the fair-share factor** is given during calculation of job priorities. 

```bash
>>> scontrol show config | grep -e ^PriorityWeightFairShare -e ^PriorityDecayHalfLife -e ^PriorityUsageResetPeriod
PriorityDecayHalfLife   = 7-00:00:00
PriorityUsageResetPeriod = NONE
PriorityWeightFairShare = 8000
```

`PriorityDecayHalfLife` influences relevance given to consumed resource by a user/account in the past. If this option is set to zero no decay will happen. Then `PriorityUsageResetPeriod` is used to rest the counters periodically. 

Usage and Shares are the two components o fair-share factor:

- **Shares** are assigned to associations, representing its "part" of the system (similar to slices of a pie). Normalized to 0.0…1.0
- **Usage** is a value between 0.0 and 1.0 that represents the accounts proportional usage of the system.
- If Shares == Usage, you have hit your **fair-share target**.

```bash
>>> sacctmgr list accounts withassoc format=account,user,share
[…]
```

Set `fairshare=` for a given account:

```bash
>>> sacctmgr modify account where name=hpc set fairshare=1000
[…]
>>> sacctmgr modify user where user=vpenso set fairshare=parent
```

Disable fair-share at certain levels of the hierarchy with `fairshare=parent`.

The algorithm use to determine the fair share factor is highly configurable. The default algorithm can be further replaced by setting options with `PriorityFlags`:

Flag                   | Description
-----------------------|-----------------------------------
FAIR_TREE              | Enable an alternative method to calculate the fair-share factor called [Fair Tree Fairshare Algorithm][02] 
DEPTH_OBLIVIOUS        | [Depth-Oblivious Fair-share Factor][03] improves fairness between accounts in deep and/or irregular hierarchies










[01]: http://slurm.schedmd.com/priority_multifactor.html
[02]: http://slurm.schedmd.com/fair_tree.html
[03]: http://slurm.schedmd.com/priority_multifactor3.html
[04]: http://slurm.schedmd.com/priority_multifactor.html#fairshare
[05]: http://slurm.schedmd.com/SC14/BYU_Fair_Tree.pdf

[tres]: http://slurm.schedmd.com/tres.html
[slurmconf]: http://manpages.debian.org/slurm.conf
[slurmdbdconf]: http://manpages.debian.org/slurmdbd.conf
[cgroupconf]: http://manpages.debian.org/cgroup.conf
[gresconf]: http://manpages.debian.org/gres.conf
[sacctmgr]: http://manpages.debian.org/sacctmgr
[squeue]: http://manpages.debian.org/squeue
[scontrol]: http://manpages.debian.org/scontrol
[sreport]: http://manpages.debian.org/sreport
[sinfo]: http://manpages.debian.org/sinfo
[sacct]: http://manpages.debian.org/sacct
[sdiag]: http://manpages.debian.org/sdiag


