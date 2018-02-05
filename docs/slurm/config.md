
# Configuration

Following a list of the most relevant configuration files:

File                           | Comment
-------------------------------|-------------------------
[slurm.conf][slurmconf]        | Configures the resource manager and the job scheduler, define nodes, partitions and policies.
[slurmdbd.conf][slurmdbdconf] | Configures the accounting database back-end daemon slurmdbd, which is required for fair-share support.
[cgroup.conf][cgroupconf]      | Configure resource isolation and containment with Linux Cgroups
topology.conf                  | Use for network topology aware scheduling by defining the switch hierachy.
[gres.conf][gresconf]          | Configure the attributes of generic resources like GPUs
nhc.conf                       | Configures the node _Node Health Check_ system.


_The configuration requires to be the same across the cluster(s)!_

Having mismatching configurations on nodes of the same cluster will lead to inconsistent behavior. Typically the configuration is distributed by mounting a shared file-system with NFS.

After altering configuration files use [scontrol][scontrol] to **reconfigure** all nodes:

```bash
>>> scontrol show config
[…]
>>> scontrol reconfigure
```

## Scheduler

_The scheduler determines what job to execute next._

Typically the scheduler considers job requests (in queue), available resources, and policy limits imposed. The **slurmctld** loops through the queues and schedules grants resource allocations over a period of time following defined priorities.  Resources the scheduler includes into match making are: Nodes, sockets, cores, CPUs, memory, generic resources (e.g. GPUs), and licenses. 

Print the **scheduler configuration** with [scontrol][scontrol]:

    » scontrol show config | grep Scheduler*         
    FastSchedule            = 1
    SchedulerParameters     = (null)
    SchedulerPort           = 7321
    SchedulerRootFilter     = 1
    SchedulerTimeSlice      = 30 sec
    SchedulerType           = sched/backfill

`SchedulerType` plug-ins available:


Plug-in          | Description
-----------------|--------------------------------------------------------
sched/builtin    | [Default] Jobs run in priority order (first-in-first-out).
sched/backfill   | Backfill is a mechanism by which lower priority jobs can start earlier to fill the idle slots provided they are finished before the next high priority jobs is expected to start based on resource availability.
sched/hold       | Jobs are scheduled by administrators.
sched/wiki       | Interfacing external schedulers Maui, Moab.

This `sched/backfill` plug-in supports following scheduling mechanisms:

Mechanism       | Comment
----------------|---------------------------------------------------
Backfill        | Fill spare resources with low priority jobs.
Preemption      | Cause lower priority jobs to relinquish resources so that higher priority jobs can be run
Gang            | Processors are over-subscribed by jobs, but the jobs take turns running by time-slicing
Topology        | Optimize job allocations with respect to network topology

_Slurm is designed to perform a quick scheduling attempt at frequent intervals, and a more comprehensive (slower) scheduling less frequently._

→ [Scheduling Configuration Guide](http://slurm.schedmd.com/sched_config.html)

**Quick scheduling** is triggered by following events:

- At each job submission
- At job completion on each of it's allocated nodes
- At configuration change 

Configurations influencing quick scheduling:

Config              | Comment
--------------------|-------------------------
default_queue_depth | Defines the number of jobs considered during quick scheduling (default 100.)
partition_job_depth | Defines how many jobs are considered in each partition (default 0 unlimited). Once any job in a partition is left pending, no other jobs in that partition are considered for scheduling (i.e. FIFO) 

Configuration in [slurm.conf][slurmconf]:

    » scontrol show config | grep SchedulerParameters
    SchedulerParameters=default_queue_depth=100,partition_job_depth=0

**Comprehensive scheduling** tests all jobs in the queue or run until reaching the configured *max_sched_time* time limit, default value is half of *MessageTimeout*. 


### Resource Enforcement 

_Slurm uses an accounting database to enforce resource [limits](#limits)._

Limits are enforced in hierarchical order:

- QOS limit
- User association
- Account association(s)
- Root/Cluster association
- Partition limit

→ [Resource Limits](http://slurm.schedmd.com/resource_limits.html)

Order in which limits get processed: 

    » grep ^Accounting slurm.conf 
    AccountingStorageEnforce=associations,limits
    […]
    AccountingStorageType=accounting_storage/slurmdbd

### Backfill

_Backfill scheduler will start lower priority jobs if doing so does not delay the expected start time of any higher priority job._

In order to allow Backfill to work **it is required to set [runtime](#runtime) limits**:

- Without backfill, each partition is scheduled strictly in priority order.
- Since the expected start time of pending jobs depends upon the expected completion time of running jobs, reasonably accurate time limits are valuable for backfill scheduling to work well.
- Backfill scheduling is a time consuming operation. Locks are periodically released briefly so that other options can be processed (e.g. submit new jobs).
- Backfill scheduling can optionally continue execution after the lock release and ignore newly submitted jobs. Doing so will permit consideration of more jobs, but may result in the delayed scheduling of newly submitted jobs 



## Resources

In order to configure Slurm to allocate resources beyond the scope of a node adjust the following parameters in the configuration. Enable the `select/cons_res` or **consumable resource** allocation plug-in and set the parameter `CR_CPU_Memory` (CPUs and memory are consumable resources):

    SelectType=select/cons_res
    SelectTypeParameters=CR_CPU_Memory,CR_ONE_TASK_PER_CORE

- The configuration above enables users to allocate individual sockets, cores and threads eventually on a single node as consumable resource. 
- The default allocation method across nodes is **block allocation** (allocate all available CPUs in a node before using another node). 
- The default allocation method within a node is **cyclic allocation** (allocate available CPUs in a round-robin fashion across the sockets within a node). The parameter `CR_ONE_TASK_PER_CORE` forces the scheduler to allocate one task per core by default. 

### Runtime


Config        | Comment
--------------|--------------------------------------------------------------------------
DefaultTime   | Default job time limit.
MaxTime       | Maximum job time limit.
OverTimeLimit | Amount by which a job can exceed its time limit before it is killed. 

Configuration in [slurm.conf][slurmconf]:

    OverTimeLimit = 0 min
    PartitionName=debug […] DefaultTime=00:02:00 MaxTime=00:20:00 […]
    PartitionName=main […] DefaultTime=01:00:00 MaxTime=24:00:00 […]

### Memory

Memory as a consumable resource with **SelectTypeParameters** in [slurm.conf][slurmconf]

```bash
>>> scontrol show config | grep SelectType
SelectType              = select/cons_res
SelectTypeParameters    = CR_CPU_MEMORY,[…]
```

Memory resources are tracked default in the accounting 

```bash
>>> scontrol show config | grep -i tres
AccountingStorageTRES   = cpu,mem,energy,node
```

Global memory limits with **DefMemPerCPU** and **MaxMemPerCPU** 

```bash
>>> scontrol show config | grep -i mempercpu
DefMemPerCPU            = 64
MaxMemPerCPU            = 256
```

Enforcement of memory limits with Cgroups **TaskPlugin**

```bash
>>> scontrol show config | grep -i taskplugin
TaskPlugin              = task/cgroup
TaskPluginParam         = (null type)
```

Enable  **ConstrainRAMSpace** [cgroup.conf][cgroupconf], cf. [Cgroups Guide](http://slurm.schedmd.com/cgroups.html)

```bash
>>> grep -i ram /etc/slurm-llnl/cgroup.conf 
ConstrainRAMSpace=yes
```

Support for memory in Cgroups on Debian

```bash
>>> grep -i cmdline_linux= /etc/default/grub 
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
>>> update-grub
>>> grep cgroup /proc/cmdline 
[…] ro cgroup_enable=memory swapaccount=1 quiet
```

If memory is a consumable resource nodes require **RealMemory** 

```bash
>>> grep ^NodeName /etc/slurm-llnl/slurm.conf 
NodeName=lxbk0[197-200] […] RealMemory=129000 […]
```

User define limits with `--mem=<MB>` and `--mem-per-cpu=<MB>` options to the submit commands:

```bash
>>> sbatch --mem 12 […] 
[…]
>>> scontrol show job $SLURM_JOBID | grep -e TRES -e MinMemoryNode
TRES=cpu=1,mem=12,node=1
MinCPUsNode=1 MinMemoryNode=12M MinTmpDiskNode=0
>>> sacct -X -o jobid,reqmem,reqtres%20,AllocTRES%20 -j 16,19
JobID     ReqMem              ReqTRES            AllocTRES 
------------ ---------- -------------------- -------------------- 
16                 12Mc  cpu=1,mem=12,node=1  cpu=1,mem=12,node=1 
19                256Mn cpu=1,mem=256,node=1 cpu=1,mem=256,node=1 
```
`Mc` memory per CPU, `Mn` memory per node




Exceeding the memory limits with a jobs results in following log information on the execution nodes:

```bash
>>> grep "\[$SLURM_JOBID\]" /var/log/slurm-llnl/slurmd.log
[…] [12] task/cgroup: /slurm/uid_1000/job_12: alloc=64MB mem.limit=64MB memsw.limit=unlimited
[…] [12] task/cgroup: /slurm/uid_1000/job_12/step_batch: alloc=64MB mem.limit=64MB memsw.limit=unlimited
[…] [12] Exceeded step memory limit at some point.
```

Similar users will get this information in stderr:

```
slurmstepd: Exceeded step memory limit at some point.
```



### Sockets, Cores and Threads

Invoking `slurmd -C` will print the execution node hardware configuration.

```bash
>>> export NODES="lxb[001-010]"
>>> clush -w $NODES "sudo slurmd -C | cut -d' ' -f2-"
---------------
lxb[001,003-007] (6)
---------------
Procs=1 Sockets=1 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=1003 TmpDisk=40869
---------------
lxb[002,008,010] (3)
---------------
Procs=2 Sockets=2 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=2012 TmpDisk=40869
---------------
lxb009
---------------
Procs=4 Sockets=4 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=1002 TmpDisk=40869
```

For the node resources collected above the configuration would look like:

```
NodeName=lxb[001,003-007] Procs=1 Sockets=1 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=1003 TmpDisk=40869
NodeName=lxb[002,008,010] Procs=2 Sockets=2 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=2012 TmpDisk=40869
NodeName=lxb[009] Procs=4 Sockets=4 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=1002 TmpDisk=40869
```

Except from the node list expression all other parameters to the _NodeName_ definition are optional. 

_However establish baseline node resource configurations, especially if the cluster is heterogeneous._

Nodes which register to the system with less than the configured resources (e.g. too little memory), will be placed in the "DOWN" state to avoid scheduling jobs on them.




### Generics Resources


[Generic Resources][gres] (GRES), accelerator hardware e.g. GPGPUs or MICs: 

- Associates with a specific node by a defined resource name identifier.
- Use plug-ins to gather device specific information. 

Enable GRES scheduling in [slurm.conf][slurmconf] with **GresTypes**:

    GresTypes=gpu,mic

Specify the resources associated with nodes using **Gres=** in the NodeName definition. 

    NodeName=[…] Gres=gpu:4 Feature=firepro

Nodes supporting GRES require a configuration file [gres.conf][gresconf]:

    NodeName=[…] Name=gpu File=/dev/ati/card[0-3]

Users can allocate GRES with **option `--gres=<list>`**:

    srun […] --gres=gpu:1 […] 
         […] --gres=gpu:2*cpu […] 

Each resource in the list is defined with `name[:count[*cpu]]`:

- name – Identifier name of the consumable resource
- count – Number of resources (default 1).
- *cpu – Allocate specified resource per CPU (instead of job on each node).


### Features

Node can have a list of strings (comma separated) associated to them called _Feature_ to indicate node characteristics.

    NodeName=[…] Feature=xeon,infiniband,[…]

List resources and features of execution nodes with: 

    » sinfo -o "%4c %10z %8d %8m %25f %N"                                 
    CPUS S:C:T      TMP_DISK MEMORY   FEATURES                  NODELIST
    40   2:10:2     561009   129079   (null)                    lxbk[0001-0200]
    40   2:10:2     550000   256000   firepro                   lxbl[0001-1000]

## Partitions

_Partitions group nodes with similar characteristics (resources, priorities, limits, access controls, etc)._

Partitions are defined in [slurm.conf][slurmconf] with the keyword **PartitionName** followed by partition specific configuration options, e.g.:

    » grep ^Partition slurm.conf 
    PartitionName=main Nodes=lxb119[3,4,6] Default=YES MaxTime=INFINITE State=UP
    PartitionName=debug Nodes=lxb1197 MaxTime=INFINITE State=UP

`Default=YES` defines the partition used for jobs without an explicitly specified option `-p partition`.

Partitions support access control with the keywords **AllowGroups**, and **AllowAccounts**. 

    » scontrol show partitions | grep -e ^Part -e All


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


