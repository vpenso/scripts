

### Simple Example

    » zpool create storage sda2
    » zpool list
    NAME      SIZE  ALLOC   FREE    CAP  DEDUP  HEALTH  ALTROOT
    storage   190G    91K   190G     0%  1.00x  ONLINE  -
    » zfs list
    NAME      USED  AVAIL  REFER  MOUNTPOINT
    storage   104K   187G    30K  /storage
    » zfs create storage/local
    » zfs list
    NAME            USED  AVAIL  REFER  MOUNTPOINT
    storage         142K   187G    30K  /storage
    storage/local    30K   187G    30K  /storage/local
    » df -h  | grep storage
    storage                                                 188G  128K  188G   1% /storage
    storage/local                                           188G  128K  188G   1% /storage/local
    » zfs set mountpoint=/local storage/local
    » mkdir local
    » zfs mount storage/local
    » mount | grep storage
    storage on /storage type zfs (rw,relatime,xattr)
    storage/local on /local type zfs (rw,relatime,xattr)

### Boot persistence

    » grep -i mount= /etc/default/zfs 
    ZFS_MOUNT='yes'
    ZFS_UNMOUNT='yes'

### Quotas

    » df -h /local
    Filesystem      Size  Used Avail Use% Mounted on
    storage         188G     0  188G   0% /local
    » zfs create -o mountpoint=/data storage/data
    » zfs list
    NAME           USED  AVAIL  REFER  MOUNTPOINT
    storage        164K   187G    30K  /local
    storage/data    30K   187G    30K  /data
    » zfs set quota=20g storage/data
    » zfs list -o quota storage/data
    QUOTA
      20G
    » dd if=/dev/zero of=/data/20g.blob bs=1024 count=$[1000*2000]
    » df -h /data
    Filesystem      Size  Used Avail Use% Mounted on
    storage/data     20G  2.0G   19G  10% /data

### RAID

In order of performance:

* `mirror` – More disks, more reliability, same capacity. (RAID 1)
* `raidz1` – Single parity, minimum 3 disks. Two disk failures results in data loss. 
* `raidz2` – Dual parity, minimum 4 disks. Allows for two disk failures.
* `raidz3` – Triple parity, minimum 5 disks. Allows for three disk failures.

Create a mirror with two disks, break it, and replace a disk:

    » zpool create -f storage mirror sdb sdc
    » zpool status storage
      pool: storage
     state: ONLINE
      scan: none requested
    config:
            NAME        STATE     READ WRITE CKSUM
            storage     ONLINE       0     0     0
              mirror-0  ONLINE       0     0     0
                sdb     ONLINE       0     0     0
                sdc     ONLINE       0     0     0
    » dd if=/dev/urandom of=/dev/sdb1 bs=1024k seek=10 count=1
    » zpool scrub storage
    » zpool status storage                                                                                   
      pool: storage
     state: ONLINE
    status: One or more devices could not be used because the label is missing or
            invalid.  Sufficient replicas exist for the pool to continue
            functioning in a degraded state.
    action: Replace the device using 'zpool replace'.
       see: http://zfsonlinux.org/msg/ZFS-8000-4J
      scan: scrub repaired 0 in 0h0m with 0 errors on Wed Jun  5 11:26:44 2013
    config:
            NAME        STATE     READ WRITE CKSUM
            storage     ONLINE       0     0     0
              mirror-0  ONLINE       0     0     0
                sdb     UNAVAIL      0     0     0  corrupted data
                sdc     ONLINE       0     0     0
    » zpool replace -f storage sdb sdd
    » zpool status storage
      pool: storage
     state: ONLINE
      scan: resilvered 10.1M in 0h0m with 0 errors on Wed Jun  5 11:29:56 2013
    config:
            NAME        STATE     READ WRITE CKSUM
            storage     ONLINE       0     0     0
              mirror-0  ONLINE       0     0     0
                sdd     ONLINE       0     0     0
                sdc     ONLINE       0     0     0

The state can be one of the following: ONLINE, FAULTED, DEGRADED, UNAVAILABLE, or OFFLINE. 

Example for a RAIDZ-1 configuration with three disks:

    » zpool create -f storage raidz1 sdb sdc sdd
    » zpool status storage
      pool: storage
     state: ONLINE
      scan: none requested
    config:
    
            NAME        STATE     READ WRITE CKSUM
            storage     ONLINE       0     0     0
              raidz1-0  ONLINE       0     0     0
                sdb     ONLINE       0     0     0
                sdc     ONLINE       0     0     0
                sdd     ONLINE       0     0     0
    » zpool list
    NAME      SIZE  ALLOC   FREE    CAP  DEDUP  HEALTH  ALTROOT
    storage   596G   194K   596G     0%  1.00x  ONLINE  -
    » df -h /storage
    Filesystem      Size  Used Avail Use% Mounted on
    storage         391G  128K  391G   1% /storage


