
## Operation

```bash
ceph status                                          # summery of state
ceph health detail
ceph osd dump
ceph-deploy --overwrite-conf config push lxmon01 lxfs01 lxfs02
                                                     # update the configuration after changes
rush 'systemctl restart ceph.target'                 # restart everything
rush 'ps -p $(pgrep ceph) -fH'                       # show the processes
```

### Monitor Servers (MONs)

Maintain the cluster state quorum:

* Provide the master copy of the CRUSH, OSD and MON maps
  - **CRUSH map** used to compute data location
  - **OSD map** reflect the OSD daemons operating in the cluster
* There must be on odd number >=3 to provide consensus of distributed decision-making (Paxos)
* Non-quorate pools are unavailable

### Object Storage Devices (OSDs)

Node hosting physical storage:

* `ceph-osd` is the object storage daemon, responsible for storing objects on a local file system and providing access to them over the network
* Requires a storage device accessible via a supported file-system (xfs, btrfs) with extended attributes
* OSD daemons are numerically identified: `osd.<id>`, and have following states `in`/`out` of the cluster, and `up`/`down`
* **Primary** OSDs are responsible for replication, coherency, re-balancing and recovery
* **Secondery** OSDs are under control of a primary OSD, and can become primary 
* Small, random I/O written sequentially to local **OSD Jounral** (improve performance with SSD)
  - Enables atomic updates to objects, and replay of the journal on restart
  - Write `ACK` when minimum replica journals written
  - Journal sync to file-system periodically to reclaim space 

```bash
/var/log/ceph/*.log                                  # logfiles on storage servers    
ceph osd stat                                        # show state 
ceph osd dump                                        # show OSD map
ceph osd tree                                        # OSD/CRUSH map as tree
ceph osd getmaxosd                                   # show number of available OSDs
ceph osd map <pool> <objname>                        # identify object location
/var/run/ceph/*                                      # admin socket
ceph daemon <socket> <command>                       # use the admin socket
ceph daemon <socket> status                          # show identity
```

### Placement Groups (PGs)

Logical collection of objects:

* CRUSH assigns objects to placement groups
* CRUSH assigns a placement group to a primary OSD
* The Primary OSD use CRUSH to replicate the PGs to the secondary OSDs
* Re-balance/recover works on all objects in a placement group
* Placement Group IDs `<pool_num>.<pg_id>` (hexadecimal)

```bash
ceph pg stat                                         # show state
ceph pg dump_stuck inactive|unclean|stale|undersized|degraded
                                                     # statisitcs for stuck PGs
ceph pg map <pgid>                                   # map a placement group
ceph pg <pgid> query                                 # statistics for a particular placement group
ceph pg scrub <pgid>                                 # check primary and replicas
```

### Pools

Logical partitions for storing object data

* Contain a defined number of PGs with a configured replication level
* PGs in pool dynamically mapped to OSDs
* Attributes for ownership/access
* CRUSH rule set mapped to pool
* Balance number of PGs per pool with the number of PGs per OSD 
  - 50-200 PGs per OSD to balance out memory and CPU requirements and per-OSD load
  - Total Placement `Groups = (OSDs*(50-200))/Number of replica`

```bash
ceph df                                              # show usage
ceph osd lspools                                     # list pools
ceph osd dump | grep 'replicated size'               # print replication level
ceph osd pool get <pool> <key>                       # read configuration attribute
ceph osd pool set <pool> <key> <value>               # set configuration attribute
```

Keys:

- `size` number of replica objects
- `min_size` minimum number of replica available for IO
- `pg_num`,`pgp_num` (effective) number of PGs to use when calculating data placement
- `crush_ruleset` to use for mapping object placement in the cluster (C


## Usage

* Objects store data and have: a name, the payload (data), and attributes
* Object namespace is flat

```bash
rados lspools                                        # list pools
rados df                                             # show pool statistics
rados mkpool <pool>                                  # create a new pool     
rados rmpool <pool>                                  # delete a pool
rados ls -p <pool>                                   # list contents of pool
rados -p <pool> put <objname> <file>                 # store object
rados -p <pool> rm <objname>                         # delete object
```

