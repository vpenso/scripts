→ [Ceph Architecture](http://docs.ceph.com/docs/jewel/architecture/)

```bash
ceph status                                          # summery of state
cpeh -s
ceph health detail
ceph -w                                              # watch mode
ceph-deploy --overwrite-conf config push <node>      # update the configuration after changes
rush 'systemctl restart ceph.target'                 # restart everything
rush 'ps -p $(pgrep ceph) -fH'                       # show the processes
```

Manage authentication keys:

```bash
ceph auth list                                       # lists authentication state
ceph auth get-or-create client.<name> <caps>         # create a new user 
```

### Monitor Servers (MONs)

Maintain the cluster state quorum:

* Provide the **master copy** of the CRUSH, OSD and MON maps
* **CRUSH map** (Controlled Replication Under Scalable Hashing (distributed hashing))
  - No centralized authority, look-up table
  - Data location algorithmically computed on clients
  - MONs not involved in data I/O path
* **OSD map** reflect the OSD daemons operating in the cluster
* There must be on odd number >=3 to provide consensus of distributed decision-making (Paxos)
* Non-quorate pools are unavailable

```bash
systemctl status ceph-mon@$(hostname)                 # daemon state       
ceph-mon -d -i $(hostname)                            # run daemon in foreground
/var/log/ceph/ceph-mon.$(hostname).log                # default log location
ceph mon stat                                         # state of all monitors
ceph -f json-pretty quorum_status                     # quorum information
ceph-conf --name mon.$(hostname) --show-config-value log_file
                                                      # get location of the log file
ceph --admin-daemon /var/run/ceph/ceph-mon.$(hostname).asok mon_status
                                                      # access a monitors admin socket
```

Manipulate the MON map:

```bash
monmap=/tmp/monmap.bin
ceph mon getmap -o $monmap                            # print the MON map if a quorum exists
ceph-mon --extract-monmap $monmap -i $(hostname)      # extract the MON map of ceph-mon stopped
monmaptool $monmap --print                            # print MON map from file
monmaptool $monmap --clobber --rm lxmon03             # remove a monitor
ceph-mon --inject-monmap $monmap -i $(hostname)       # store new map
```

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
cpeh osd df                                          # storage utilization by OSD
ceph node ls osd                                     # list OSDs
ceph osd dump                                        # show OSD map
# OSD ID to host IP, port mapping
ceph osd dump | grep '^osd.[0-9]*' | tr -s ' ' | cut -d' ' -f1,2,14
ceph osd tree                                        # OSD/CRUSH map as tree
ceph osd getmaxosd                                   # show number of available OSDs
ceph osd map <pool> <objname>                        # identify object location
/var/run/ceph/*                                      # admin socket
ceph daemon <socket> <command>                       # use the admin socket
ceph daemon <socket> status                          # show identity
```

Manipulate the CRUSH map:

```bash
ceph osd getcrushmap -o /tmp/crushmap.bin                    # extract teh CRUSH map 
crushtool -d /tmp/crushmap.bin -o /tmp/crushmap.txt          # decompile binary CRUSH map
crushtool -c /tmp/crushmap.txt -o /tmp/crushmap.bin          # compile CRUSH map
ceph osd setcrushmap -i /tmp/crushmap.bin                    # inject CRUSH map
```

Remove an OSD from production:

```bash
ceph osd out <num>                                   # remove OSD, begin rebalancing
systemctl stop ceph-osd@<num>                        # stop the OSD daemon on the server 
ceph osd crush remove osd.<num>                      # remove the OSD from the CRUSH map
ceph auth del osd.<num>                              # remove authorization credential
ceph osd rm osd.<num>                                # remove OSD from configuration
# remove from clean ceph.conf if required 
```




### Pools

Logical partitions for storing object data:

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
ceph osd dump | grep ^pool                           # list replication size
cpeh osd pool create <name> <pgs> <pgs>              # create a pool 
ceph osd pool get <pool> <key>                       # read configuration attribute
ceph osd pool set <pool> <key> <value>               # set configuration attribute
```

Keys:

- `size` number of replica objects
- `min_size` minimum number of replica available for IO
- `pg_num`,`pgp_num` (effective) number of PGs to use when calculating data placement
- `crush_ruleset` to use for mapping object placement in the cluster (C

States:

- `active+clean` – optimum state
- `degraded` – not enough replicas to meet requirement
- `down` – no OSD available storing PG
- `inconsistent` – PG nor consistent across different OSDs
- `repair` – correcting inconsistent PGs to meet replication requirements




### Placement Groups (PGs)

Logical collection of objects:

* CRUSH assigns objects to placement groups
* CRUSH assigns a placement group to a primary OSD
* The Primary OSD use CRUSH to replicate the PGs to the secondary OSDs
* Re-balance/recover works on all objects in a placement group
* Placement Group IDs (pgid) `<pool_num>.<pg_id>` (hexadecimal)

```bash
ceph pg stat                                         # show state
ceph pg ls-by-osd <num>                              # lost PGs store on OSD
```

```bash
ceph pg map <pgid>                                   # map a placement group
```
```
osdmap e20 pg 2.f22 (2.22) -> up [0,1,2] acting [0,1,2]
       │   │                  │          └── acting set of OSDs responsible for a particular PG
       │   │                  └───────────── matches "acting set" unless rebalancing in progress 
       │   └──────────────────────────────── placement group number                   
       └──────────────────────────────────── monotonically increasing OSD map version number
```
```bash
ceph pg dump_stuck inactive|unclean|stale|undersized|degraded
                                                     # statisitcs for stuck PGs
ceph pg <pgid> query                                 # statistics for a particular placement group
ceph pg scrub <pgid>                                 # check primary and replicas
```

