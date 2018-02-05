
Control Groups cgroups is a Linux kernel mechanism (appeared in 2.6.24) to limit, isolate and monitor resource usage (CPU, memory, disk I/O, etc.) of groups of processes. Slurm uses this mechanism to:

- Limit consumable resources of jobs.
- Improved tasks isolation upon resources.
- Improved robustness (e.g. more reliable cleanup of jobs)
- Improved efficiency of Slurm activities (e.g., process tracking, collection of accounting statistics) 

Slurm plug-ins:

Plug-in               | Comment
----------------------|-----------------------------------------------------------------------------------
proctrack/cgroup      | Uses the Cgroup freezer subsystem to track processes and suspend/resume job steps. 
task/cgroup           | Uses the Cgroup cpuset subsystem to bind processes to CPU cores (task affinity.) 
jobacct_gather/cgroup | Collects accounting statistics for jobs, steps and tasks (alternative to jobacct_gather/linux)

Enable these in `slurm.conf`:

```bash
>>> grep cgroup slurm.conf
ProctrackType=proctrack/cgroup
JobAcctGatherType=jobacct_gather/cgroup
TaskPlugin=task/cgroup
```

The `cgroup.conf` file is read by all components using these facilities. 

```bash
>>> cat cgroup.conf         
# Mount required cgroup subsystems if required
CgroupAutomount=yes
# PATH under which cgroups should be mounted
CgroupMountpoint=/sys/fs/cgroup
# Constrain allowed cores to the subset of allocated resources
ConstrainCores=yes
# Bind each step task to a subset of the allocated cores
TaskAffinity=yes
# Constrain the job's RAM usage by setting the memory soft limit 
# to the allocated memory and the hard limit to the allocated memory
ConstrainRAMSpace=yes
# Constrain the job's allowed devices based on GRES allocated resources
ConstrainDevices=yes
# prevents the kernel from swapping out program data
MemorySwappiness=0
```

For example the following output shows a job requesting one CPU (here with hyperthreading), but starting for processes. 

```bash
>>> sbatch --cpus-per-task 1 -p debug stress.sh 100s 4 500M
>>> ps -u vpenso -o pid,%cpu,args
  PID %CPU COMMAND
36679  0.0 /bin/bash /var/lib/slurm-llnl/slurmd/job00118/slurm_script 100s 4 500M
36689 51.0 stress --vm 4 --vm-bytes 500M --timeout 100s
36690 51.0 stress --vm 4 --vm-bytes 500M --timeout 100s
36691 50.7 stress --vm 4 --vm-bytes 500M --timeout 100s
36692 50.7 stress --vm 4 --vm-bytes 500M --timeout 100s
```
