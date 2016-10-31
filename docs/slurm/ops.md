
### Users

Wrapper to the Slurm command-line interface ↴ [slurm](../../bin/slurm) 

```bash
scontrol -d show job <jobid>                                        # show single job details
for i in $(squeue -u <user> -o '%i' -h) ; do scontrol show job $i ; done
                                                                    # show all jobs of a user
scontrol show job <jobid> | grep Requeue                            # show requeue behavior of job
scontrol update jobid=<jobid> requeue=0                             # disable requeue
squeue -t r -A <account>                                            # running by account
squeue -t r -o '%20S %11M %9P %8u %6g %10T %11l' | sort -k 1 | uniq -f 2 -c | tac
                                                                    # running by runtime
squeue -t r -o '%11M %11l %9P %8u %6g %10T' -S '-M' | uniq -f 1 -c  # running by execution time 
squeue -t r -ho %A -u <user> | paste -sd' '                         # IDs of running jobs by user
squeue -t pd -o '%15i %30R %o' -u <user>                            # pending by user
squeue --start                                                      # estimated start time of jobs
squeue -t pd,s -o '%20S %.8u %4P %7a %.2t %R' -S 'S' | uniq -c      # ^^ summery
squeue -t pd -o '%8u %8a %8Q' -S -p | uniq -c                       # pending by priority
man -P 'less -p "^JOB REASON CODES"' squeue                         # list of "Job Reason Codes"
scontrol suspend $(squeue -ho %A -t R -u <user> | paste -sd ' ')    # suspend running jobs of user
scontrol resume $(squeue -ho %A -t S -u <user> | paste -sd ' ')     # resume suspended jobs of user
scontrol show reservation                                           # list reservations
scontrol create reservation starttime=YYYY-MM-DDTHH:MM:SS user=root duration=120 flags=maint,ignore_jobs nodes=all
                                                                    # reserver all nodes from given start time
scontrol create reservation starttime=now user=root duration=infinite flags=maint nodes=<node>
                                                                    # reserve node for ever
scontrol create reservation [...] partition=main nodecnt=<num> account=<account> user=<user>
                                                                    # reserve hardware for user
sacct -o jobid,state,submit,start,end,cputimeraw -S $(date --date="12 hours ago" +"%H:%m") -u <user>
                                                                    # user jobs from the laste 12 hours
```

### Services

**Nodes**

```bash
sinfo -R -p <partition>                                             # defect nodes in partition
sinfo -o '%10T %5D %E' -S 'E' -t drain,draining,drained,down        # defect nodes by numbers
sinfo -o '%10T %7u %12n %E' -S 'E' -t drain,draining,drained,down   # defect nodes by reaseons
squeue -h -t cg -o '%A,%N' -S N | cut -d, -f2 | uniq                # nodes in completing state
squeue -h -t cg -o '%A %N' -S N | uniq -c -f 1 | tr -s ' ' | cut -d' ' -f2,4
                                                                    # number of completing jobs per node
squeue -t r -ho %N -u <user> | nodeset -f                           # nodes with running jobs by user
scontrol show node <node>                                           # node details
sacctmgr -n show event format=state,nodename,start,end,duration,reason nodes=<nodeset>
                                                                    # node event list
man -P 'less -p "^NODE STATE CODES"' sinfo                          # node state list
scontrol update state=drain nodename=<nodeset> reason="<comment>"   # drain a node
```

**Controller**

```bash
systemctl status munge nfs-kernel-server slurmdbd slurmctld         # state of controller services
multitail /var/log/slurm-llnl/*.log                                 # read logs
scontrol show config | grep Scheduler*                              # show scheduler config
sdiag                                                               # scheduler diagnostics
```

