
### Operation

Wrapper to the Slurm command-line interface ↴ [slurm](../../bin/slurm) 

```bash
scontrol -d show job <jobid>                                        # show single job details
for i in $(squeue -u <user> -o '%i' -h) ; do scontrol show job $i ; done
                                                                    # show all jobs of a user
scontrol show job <jobid> | grep Requeue                            # show requeue behavior of job
scontrol update jobid=<jobid> requeue=0                             # disable requeue
```
```bash
squeue -t R -A <account>                                            # running by account
squeue -t R -o '%20S %11M %9P %8u %6g %10T %11l' | sort -k 1 | uniq -f 2 -c | tac
                                                                    # running by runtime
squeue -t r -o '%11M %11l %9P %8u %6g %10T' -S '-M' | uniq -f 1 -c  # running by execution time 
squeue -ho %A -t R -u <user> | paste -sd' '                         # IDs of running jobs by user
```
```bash
squeue -t PD -o '%15i %30R %o' -u <user>                            # pending by user
squeue --start                                                      # estimated start time of jobs
squeue -t pd,s -o '%20S %.8u %4P %7a %.2t %R' -S 'S' | uniq -c      # ^^ summery
squeue -t pd -o '%8u %8a %8Q' -S -p | uniq -c                       # pending by priority
man -P 'less -p "^JOB REASON CODES"' squeue                         # list of "Job Reason Codes"
```
```bash
scontrol suspend $(squeue -ho %A -t R -u <user> | paste -sd ' ')    # suspend running jobs of user
scontrol resume $(squeue -ho %A -t S -u <user> | paste -sd ' ')     # resume suspended jobs of user
scontrol show reservation                                           # list reservations
scontrol create reservation starttime=YYYY-MM-DDTHH:MM:SS user=root duration=120 flags=maint,ignore_jobs nodes=all
                                                                    # reserver all nodes from given start time
scontrol create reservation starttime=now user=root duration=infinite flags=maint nodes=<node>
                                                                    # reserve node for ever
scontrol create reservation [...] partition=main nodecnt=<num> account=<account> user=<user>
                                                                    # reserve hardware for user
```

### Services

```bash
sinfo -o '%10T %5D %E' -S 'E' -t drain,draining,drained,down        # number of nodes in defect states
sinfo -o '%10T %7u %12n %E' -S 'E' -t drain,draining,drained,down   # reaseons nodes are defect
scontrol show node <node>                                           # node details
sacctmgr -n show event format=state,nodename,start,end,duration,reason nodes=<nodeset>
                                                                    # events for a set of nodes
scontrol update state=drain nodename=<nodeset> reason="<comment>"   # drain nodes
```
```bash
systemctl status munge nfs-kernel-server slurmdbd slurmctld         # state of controller services
multitail /var/log/slurm-llnl/*.log                                 # read logs
scontrol show config | grep Scheduler*                              # show scheduler config
sdiag                                                               # scheduler diagnostics
```

