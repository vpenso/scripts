
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


### Multifactor Priorities

_The Slurm Multi-factor Job Priority plugin provides a very versatile facility for ordering the queue of jobs waiting to be scheduled._

→ [Multifactor Priority Plugin](http://slurm.schedmd.com/priority_multifactor.html)

**Five factors influence job priority**

Factor     | Description
-----------|-----------------------------------------------------
Age        | Length of time a job has been waiting in the queue
Fair-share | Lon-term balancing of defined account shares
Job size   | Number of nodes or CPUs a job wants to allocate
Partition  | A factor associated with each node partition
QOS        | A factor associated with each Quality Of Service

Configuration options in [slurm.conf][slurmconf] related to the multi-factor plug-in:

    » scontrol show config | grep ^Priority
    PriorityDecayHalfLife   = 7-00:00:00
    PriorityCalcPeriod      = 00:05:00
    PriorityFavorSmall      = 0
    PriorityFlags           = 0
    PriorityMaxAge          = 7-00:00:00
    PriorityUsageResetPeriod = NONE
    PriorityType            = priority/multifactor
    PriorityWeightAge       = 0
    PriorityWeightFairShare = 0
    PriorityWeightJobSize   = 0
    PriorityWeightPartition = 0
    PriorityWeightQOS       = 0

Configurations related to the five factors:

Configuration       | Description
--------------------|--------------------------------------------------------------------
PriorityMaxAge      | Length of time until the age factor will max out to 1.0
PriorityFavorSmall  | With job size factor NO, the larger the job, the greater its job size factor will be.
PriorityWeight      | Weights of the five factors, should start around 1000 to get a set of significant digits in floating point arithmetic. 

Configurations related to the priority calculation:

Configuration         | Description
----------------------|------------------------------------------------------------------
PriorityDecayHalfLife | The larger the number, the longer past usage affects fair-share.
PriorityCalcPeriod    | The period of time in minutes in which the half-life decay will be re-calculated. 

The **partition factor** can be configured for each partition in [slurm.conf][slurmconf]:

    PartitionName=main Nodes=lxbk00[0-63] Shared=NO Default=YES
    PartitionName=p2 […] Priority=2 […]
    PartitionName=p3 […] Priority=3 […]
    PartitionName=p4 […] Priority=1000 […]


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

The option `association` prevents users without an associated account in the database to access the cluster. Following error message will displayed:

    error: Unable to allocate resources: Invalid account or account/partition combination specified

The `limit` option enforces resource limits defined in the accounts database. 


### Backfill

_Backfill scheduler will start lower priority jobs if doing so does not delay the expected start time of any higher priority job._

In order to allow Backfill to work **it is required to set [runtime](#runtime) limits**:

- Without backfill, each partition is scheduled strictly in priority order.
- Since the expected start time of pending jobs depends upon the expected completion time of running jobs, reasonably accurate time limits are valuable for backfill scheduling to work well.
- Backfill scheduling is a time consuming operation. Locks are periodically released briefly so that other options can be processed (e.g. submit new jobs).
- Backfill scheduling can optionally continue execution after the lock release and ignore newly submitted jobs. Doing so will permit consideration of more jobs, but may result in the delayed scheduling of newly submitted jobs 





## Accounts


_The Slurm account configuration can be altered with the command [sacctmgr][sacctmgr] by changing associations in the database (including resource limits and fair-share)._

Accounting records are maintained based upon what is called an **association**:

- An association is a combination of cluster(, partition), account and user name. Each association can have a fair-share allocation of resources and a multitude of association specific and group (association + children) limits. 
- Note that account names must be unique, they can not be repeated at different points in the hierarchy. Limits assigned to a parent association are inherited.

Check the **consistency** of the account configuration with [sacctmgr][sacctmgr]:

    » sacctmgr show problem
    […]

### Clusters

The _ClusterName_ in [slurm.conf][slurmconf] defines the cluster name.

    » scontrol show config | grep ClusterName 
    ClusterName             = virgo
    » sacctmgr -i add cluster virgo
    […]
    » sacctmgr list cluster
    […]

Each cluster needs to be initialized in the database using its name before accounts can be added. 

### Accounts


Add accounts (groups) before adding users (multiple accounts can be added at the same time by comma separating the names).

    » sacctmgr add account alice description="alice" organization="cern"
    […]
    » sacctmgr list account
    […]
    » sacctmgr delete account alice
    […]
    » sacctmgr modify account name=alice set organization=cern

Accounts may be arranged in a hierarchical fashion, limits are inherited by children.

    » sacctmgr add account train parent=alice description=train organization=cern

### Users

Add/modify user account associations:

    » sacctmgr create user name=dklein account=hpc defaultaccount=hpc
    […]
    » sacctmgr modify user where user=vpenso set defaultaccount=hpc
    […]
    » sacctmgr list users
    […]

Display associations with a specific table format:

    » sacctmgr list association format=account,user,share,maxcpus,maxsubmitjobs
       Account       User     Share  MaxCPUs MaxSubmit 
    ---------- ---------- --------- -------- --------- 
         alice                   30                    
           cbm                   20                    
         hades                   20                    
           hpc                   10       40        10 
           hpc     dklein    parent       40        10 
           hpc     vpenso    parent       40        10 
         panda                   20                    

### Coordinators

Coordinators have permission to add users or sub-accounts, modify fair-share and limits to the accounts and users they are coordinator over.

Add coordinators to a given account:

    » sacctmgr add coordinator account=hpc names=vpenso,dklein
    […]

List the coordinator accounts for a user:

    » sacctmgr list users where name=vpenso WithCoordinator
          User   Def Acct     Admin       Coord Accounts 
    ---------- ---------- --------- -------------------- 
        vpenso        hpc      None                  hpc

List the coordinators for a given account:

    » sacctmgr list account where account=hpc WithCoordinator
       Account                Descr                  Org       Coord Accounts 
       ---------- -------------------- -------------------- -------------------- 
              hpc                  hpc                  gsi        dklein,vpenso 


Coordinators can operate following commands on their accounts:

    sacctmgr create user
    scontrol show job
    scontrol update job
    scontrol requeue
    scontrol show step
    scontrol update step
    scancel

### Admins

Admin users can operate the accounting database, and alter anything on an instance of slurmctld as if root.

    » sacctmgr modify user where user=vpenso set adminlevel=admin

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

Configuration in [slurm.conf][slurmconf]:

```bash
>>> scontrol show config | grep -i mempercpu
DefMemPerCPU            = 64
MaxMemPerCPU            = 256
```

**Enforce memory limits**, cf. [cgroup.conf][cgroupconf] and [Cgroups Guide](http://slurm.schedmd.com/cgroups.html):

```bash
>>> scontrol show config | grep -i taskplugin
TaskPlugin              = task/cgroup
TaskPluginParam         = (null type)
>>> grep -i ram /etc/slurm-llnl/cgroup.conf 
ConstrainRAMSpace=yes
>>> grep -i cmdline_linux= /etc/default/grub 
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
>>> update-grub
```
```bash
>>> grep cgroup /proc/cmdline 
[…] ro cgroup_enable=memory swapaccount=1 quiet
```

If memory is a consumable resource node require `RealMemory` to be configured, cf. [slurm.conf][slurmconf]:

```bash
» grep ^NodeName /etc/slurm-llnl/slurm.conf 
NodeName=lxbk0[197-200] […] RealMemory=129000 […]
```

Submission commands will define memory resource limits with the options `--mem=MB` and -`-mem-per-cpu=MB`. 


### Sockets, Cores and Threads

Invoking `slurmd -C` will print the execution node hardware configuration.

    » export NODES="lxb[001-010]"
    » clush -w $NODES "sudo slurmd -C | cut -d' ' -f2-"
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

For the node resources collected above the configuration would look like:

    NodeName=lxb[001,003-007] Procs=1 Sockets=1 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=1003 TmpDisk=40869
    NodeName=lxb[002,008,010] Procs=2 Sockets=2 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=2012 TmpDisk=40869
    NodeName=lxb[009] Procs=4 Sockets=4 CoresPerSocket=1 ThreadsPerCore=1 RealMemory=1002 TmpDisk=40869

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

### Isolation

Control Groups cgroups is a Linux kernel mechanism (appeared in 2.6.24) to limit, isolate and monitor resource usage (CPU, memory, disk I/O, etc.) of groups of processes. Slurm uses this mechanism to:

- Limit consumable resources of jobs.
- Improved tasks isolation upon resources.
- Improved robustness (e.g. more reliable cleanup of jobs)
- Improved efficiency of Slurm activities (e.g., process tracking, collection of accounting statistics) 

Slurm plug-ins relates to Cgroups:

Plug-in          | Comment
-----------------|-----------------------------------------------------------------------------------
proctrack/cgroup | Uses the Cgroup freezer subsystem to track processes and suspend/resume job steps. 
task/cgroup      | Uses the Cgroup cpuset subsystem to bind processes to CPU cores (task affinity.) 

Enable these in [slurm.conf][slurmconf]:

    » grep cgroup slurm.conf 
    ProctrackType=proctrack/cgroup
    TaskPlugin=task/cgroup

The [cgroup.conf][cgroupconf] file is read by all components using these facilities. 

    » cat /etc/slurm-llnl/cgroup.conf 
    CgroupAutomount=yes
    ConstrainCores=yes


Config             | Comment
-------------------|---------------------------
CgroupAutomount    | Mount the cgroup pseudo file-system to `/cgroup` if not available yet:
ConstrainCores     | Limits the jobs access to CPU resources to the defined number of cores. 

For example the following output shows a job requesting one CPU (here with hyperthreading), but starting for processes. 

    » sbatch --cpus-per-task 1 -p debug stress.sh 100s 4 500M
    » ps -u vpenso -o pid,%cpu,args
      PID %CPU COMMAND
    36679  0.0 /bin/bash /var/lib/slurm-llnl/slurmd/job00118/slurm_script 100s 4 500M
    36689 51.0 stress --vm 4 --vm-bytes 500M --timeout 100s
    36690 51.0 stress --vm 4 --vm-bytes 500M --timeout 100s
    36691 50.7 stress --vm 4 --vm-bytes 500M --timeout 100s
    36692 50.7 stress --vm 4 --vm-bytes 500M --timeout 100s





## Partitions

_Partitions group nodes with similar characteristics (resources, priorities, limits, access controls, etc)._

Partitions are defined in [slurm.conf][slurmconf] with the keyword **PartitionName** followed by partition specific configuration options, e.g.:

    » grep ^Partition slurm.conf 
    PartitionName=main Nodes=lxb119[3,4,6] Default=YES MaxTime=INFINITE State=UP
    PartitionName=debug Nodes=lxb1197 MaxTime=INFINITE State=UP

`Default=YES` defines the partition used for jobs without an explicitly specified option `-p partition`.

Partitions support access control with the keywords **AllowGroups**, and **AllowAccounts**. 

    » scontrol show partitions | grep -e ^Part -e All

## Limits

_Used to set resource limits on a more finer-grained basis then partition limits._

Note that this require [resource enforcement](#resource-enforcement) to be configured.

Parent association **limits are inherited by children**, unless dedicated limits have been set (children can have limits higher then their parents).

Limit         | Description
--------------|-------------------------------------------------------
GrpCPUMins    | Hard limit of CPU minutes
GrpCPUs       | Total count of CPUs able to be used
GrpJobs       | Total number of jobs able to run at any given time
GrpMemory     | Total amount of memory (MB) able to be used
GrpNodes      | Total count of nodes able to be used at any given time
GrpSubmitJobs | Total number of jobs able to be submitted
GrpWall       | Maximum wall clock time any job submitted 



### CPUtime

_Limit on the remaining CPU time per account/user_

Once this limit is reached no more jobs are allowed to start.

    » sacctmgr show associations format=account,user,grpcpurunmins

→ [Remaining Cputime Per User/Account](http://tech.ryancox.net/2014/04/scheduler-limit-remaining-cputime-per.html)

Clear a resource limit for a particular user:

    » sacctmgr modify user vpenso set GrpCPUs=-1

### Shares

Report scheduling performance with [sdiag][sdiag]

List accounts with users and their share:

    » sacctmgr list accounts format=account,user,share WithAssoc

Set a fair-share value for a given account:

    » sacctmgr modify account where name=hpc set fairshare=10



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


