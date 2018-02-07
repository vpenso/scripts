
_The Slurm account configuration can be altered with the command [sacctmgr][sacctmgr] by changing associations in the database (including resource limits and fair-share)._

Account records are maintained based on **associations**:

* Associations are a combination of: cluster, (partition,) account, user
* Associations have a fair-share allocation and group limits
* Account names must be unique, can't be repeated inside the hierarchy
* Accounts inherit limits assigned to a parent association


Check the **consistency** of the account configuration with [sacctmgr][sacctmgr]:

```bash
sacctmgr show problem # cheek config consistency
scontrol show config | grep ClusterName            # show the name of the cluster
sacctmgr -i add cluster $name                      # add a new cluster to the database
sacctmgr list cluster                              # list all cluster in the database
```

## Accounts

Add accounts (groups) before adding users (multiple accounts can be added at the same time by comma separating the names).

```bash
sacctmgr list account                              # list all accounts
# add/modify the account configuration
sacctmgr add account $name description="$text" organization=$org
sacctmgr modify account name=$name set organization=$org
sacctmgr delete account $name                      # remove an account
# accounts may be arranged in a hierarchical fashion, limits are inherited by children.
sacctmgr add account $name parent=$parent description="$text" organization=$org
```

## Ueers

Users associated with an account can have multiple roles:

Role        | Description
------------|-------------
User        | (Linux) Account able to request resources
Coordinator | Representative from a working group managing a single account
Operator    | Creates and manages accounts in general
Admin       | Owns all available privileges (like root)

Users `name=` requires to be the Linux account name (check with `id $name`)!

```bash
# list all user associations
sacctmgr list users                                               
# list all association for given user name
sacctmgr show user withassoc format=account,user,defaultaccount where user=$name
# custom format for listing associations
sacctmgr list association format=account,user,share,maxcpus,maxsubmitjobs
```

Create, modify and remove users:

```bash
# create a user and associate it to an existing account
sacctmgr create user name=$name account=$account defaultaccount=$account
# modifiy a user association
sacctmgr modify user where user=$name set $key=$value             
# remove a users account association
sacctmgr delete user name=$name account=$account                  
```

### Administrator

Admin users can operate the accounting database, and alter anything on an instance of slurmctld as if root.

```bash
# grant admin priviliges to a user
sacctmgr modify user where user=<name> set adminlevel=admin
# list all user with admin priviliges
sacctmgr show user withassoc format=user,adminlevel where adminlevel=admin
```
Options for `adminlevel=`

Level    | Description
---------|--------------
none     | Regular user, no special privileges
operator | Can add, modify, and remove any database object (user, account, etc), and add other operators
admin    | Act as if root

### Coordinator

Privileged account user with permission to:

* Add users to the account
* Create sub-accounts
* Modify fair-share and limits to the accounts and users
* Control all jobs associated to the account
* Grant coordinator privileges to other users

Coordinators can operate following commands:

```
sacctmgr create user
sacctmgr modify user
scontrol show job
scontrol update job
scontrol requeue
scontrol hold
scontrol release
scontrol show step
scontrol update step
scancel
```

**Promote a user to be coordinator** for a given account:

```bash
sacctmgr add coordinator account=<account> names=<id>,...     # add coordinator(s) to account
sacctmgr list user withcoordinator where name=<id>            # show coordinator for association 
sacctmgr list account withcoordinator where account=<account> # list coordinators for a given account
sacctmgr list user withcoordinator format=user,coordinator -P | tr '|' ' ' | awk 'NF==2'
                                                             # print a list of all coordinators          
```

### Association Enforcement


**Enforce user account associations** in `slurm.conf` with:

```bash
>>> scontrol show config | grep AccountingStorageEnforce
AccountingStorageEnforce = associations,[...]
```

This prevents users without an account association to submit jobs.

**Force option `--account`** to be specified by users. Slurm provides two options to implement this:

I. Create an account `none` which has no access to resources. Use it as `defaultaccount=none` for users which should be force to specify the option. (Note that beforehand a users needs to be associated to the "none" account). Following error will be printed:

```
Unable to allocate resources: Job violates accounting/QOS policy (job submit limit, user's size and/or time limits)
```

II. Alternatively Use a [Job Submit Plugin](http://slurm.schedmd.com/job_submit_plugins.html) to enforce the option for all users:

```lua
if job_desc.account == nil then
  slurm.user_msg("You didn't specify a account.")
  return 2045
end
```


## Limits

Set [Resource Limits](http://slurm.schedmd.com/resource_limits.html) on a more finer-grained basis then partition limits:

```
>>> scontrol show config | grep AccountingStorageEnforce
AccountingStorageEnforce = [...],limits
```

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

Set limits for a given user:

```bash
» sacctmgr modify user vpenso set GrpJobs=1000
```

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


