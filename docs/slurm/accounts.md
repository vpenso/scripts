
# Configuration

_The Slurm account configuration can be altered with the command [sacctmgr][sacctmgr] by changing associations in the database (including resource limits and fair-share)._

Account records are maintained based on associations:

* Associations are a combination of: cluster, (partition,) account, user
* Associations have a fair-share allocation and group limits
* Account names must be unique, can't be repeated inside the hierarchy
* Accounts inherit limits assigned to a parent association


Check the **consistency** of the account configuration with [sacctmgr][sacctmgr]:

```bash
>>> sacctmgr show problem
```

## Clusters

The _ClusterName_ in [slurm.conf][slurmconf] defines the cluster name.

```bash
>>> scontrol show config | grep ClusterName 
ClusterName             = virgo
>>> sacctmgr -i add cluster virgo
[…]
>>> sacctmgr list cluster
[…]
```

Each cluster needs to be initialized in the database using its name before accounts can be added. 

## Accounts


Add accounts (groups) before adding users (multiple accounts can be added at the same time by comma separating the names).

```bash
>>> sacctmgr add account alice description="alice" organization="cern"
[…]
>>> sacctmgr list account
[…]
>>> sacctmgr delete account alice
[…]
>>> sacctmgr modify account name=alice set organization=cern
```

Accounts may be arranged in a hierarchical fashion, limits are inherited by children.

```bash
>>> sacctmgr add account train parent=alice description=train organization=cern
```

## Users

Add/modify user account associations:

```bash
>>> sacctmgr create user name=dklein account=hpc defaultaccount=hpc
[…]
>>> sacctmgr modify user where user=vpenso set defaultaccount=hpc
[…]
>>> sacctmgr list users
[…]
```

Display associations with a specific table format:

```bash
>>> sacctmgr list association format=account,user,share,maxcpus,maxsubmitjobs
```

## Coordinators

Coordinators have permission to add users or sub-accounts, modify fair-share and limits to the accounts and users they are coordinator over.

Add coordinators to a given account:

```bash
>>> sacctmgr add coordinator account=hpc names=vpenso,dklein
```

List the coordinator accounts for a user:

```bash
>>> sacctmgr list users where name=vpenso WithCoordinator
      User   Def Acct     Admin       Coord Accounts 
---------- ---------- --------- -------------------- 
    vpenso        hpc      None                  hpc
```

List the coordinators for a given account:

```bash
>>> sacctmgr list account where account=hpc WithCoordinator
```

Coordinators can operate following commands on their accounts:

    sacctmgr create user
    scontrol show job
    scontrol update job
    scontrol requeue
    scontrol show step
    scontrol update step
    scancel

## Admins

Admin users can operate the accounting database, and alter anything on an instance of slurmctld as if root.

```bash
>>> sacctmgr modify user where user=vpenso set adminlevel=admin
```

## Limits

_Used to set resource limits on a more finer-grained basis then partition limits._

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

Once a limit is reached no more jobs are allowed to start.

```bash
>>> sacctmgr show associations format=account,user,grpcpurunmins
```

→ [Remaining Cputime Per User/Account](http://tech.ryancox.net/2014/04/scheduler-limit-remaining-cputime-per.html)

Clear a resource limit for a particular user:

```bash
>>> sacctmgr modify user vpenso set GrpCPUs=-1
```

## Shares

List accounts with users and their share:

```bash
>>> sacctmgr list accounts format=account,user,share WithAssoc
```

Set a fair-share value for a given account:

```bash
>>> sacctmgr modify account where name=hpc set fairshare=10
```

# Management

`sacctmgr` supports **retrieving the association data including limits** from the accounting database. It will be stored to a plain text file, which allows to alter the configuration, and to load it back into the accounting database. 

_Note that this does not include the accounting data like counters for consumed resources. In order to preserve this data it is required to backup the accounting database, for example by dumping the table space using the database management._

Find more detailed information in the man page:

```bash
>> LESS="-p FLAT FILE DUMP AND LOAD" man -P less sacctmgr
```

`dump` and `load` the account association data to/from a file. Each cluster requires to be dumped into a dedicated file. Print a list of the clusters: 

```bash
>>> sacctmgr list cluster format=cluster,controlhost,controlport,rpc --noheader
```

Dump the associations to a file:

```bash
>>> sacctmgr dump cluster=$NAME file=$NAME.cfg
```

Load the associations from a file

```bash
>>> sacctmgs load cluster=$NAME file=$NAME.cfg
```


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


