
↴ [slurm](../../bin/slurm)

```bash
sinfo -o "%5D %10l %7z %4c %8m %10f %P"                             # consumable hardware resources
squeue -t R -A <account>                                            # running jobs by account
squeue -t R -o '%20S %11M %9P %8u %6g %10T %11l' | sort -k 1 | uniq -f 2 -c | tac
                                                                    # running jobs by runtime
squeue -t r -o '%11M %11l %9P %8u %6g %10T' -S '-M' | uniq -f 1 -c  # running jobs by execution time 
squeue -ho %A -t R -u <user> | paste -sd' '                         # running job IDs of user
squeue -t pd -o '%8u %8a %8Q' -S -p | uniq -c                       # queued jobs by priority
squeue --start                                                      # estimated start time of jobs
squeue -t pd,s -o '%20S %.8u %4P %7a %.2t %R' -S 'S' | uniq -c      # ^^ summery
man -P 'less -p "^JOB REASON CODES"' squeue                         # list of "Job Reason Codes"
squeue -t PD -o '%15i %30R %o' -u <user>                            # pending jobs by user
for i in $(squeue -u <user> -o '%i' -h) ; do scontrol show job $i ; done
                                                                    # show all jobs of a user
scontrol suspend $(squeue -ho %A -t R -u <user> | paste -sd ' ')    # suspend running jobs of user
scontrol resume $(squeue -ho %A -t S -u <user> | paste -sd ' ')     # resume suspended jobs of user
scontrol show job <jobid> | grep Requeue                            # show requeue behavior of job
scontrol update jobid=<jobid> requeue=0                             # disable requeue
```
```bash
scontrol show reservation                                           # list reservations
scontrol create reservation starttime=YYYY-MM-DDTHH:MM:SS user=root duration=120 flags=maint,ignore_jobs nodes=all
                                                                    # reserver all nodes from given start time
scontrol create reservation starttime=now user=root duration=infinite flags=maint nodes=<node>
                                                                    # reserve node for ever
scontrol create reservation [...] partition=main nodecnt=<num> account=<account> user=<user>
                                                                    # reserve hardware for user
```


