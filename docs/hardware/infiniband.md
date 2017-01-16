# Infiniband

* InfiniBand Architecture (IBA)
  - Architecture for Interprocess Communication (IPC) networks
  - Switch-based, point-to-point interconnection network 
  - low latency, high throughput, quality of service 
  - CPU offload, hardware based transport protocol, bypass of the kernel
* [OpenFabrics][02] Alliance (OFA) 
  - Builds open-source software: **OFED** (OpenFabrics Enterprise Distribution)
  - Kernel-level drivers, channel-oriented RDMA and send/receive operations
  - Kernel and user-level application programming interface (API) 
  - Services for parallel message passing (MPI)
  - Includes Open Subnet Manager with diagnostic tools
  - IP over Infiniband (IPoIB), Infiniband Verbs/API

Data rates:

```
                                  SpeedxWidth Rate
1999    SDR   Single Data Rate    2.5Gbps x4  10Gbps   5usec        
2004    DDR   Double Data Rate      5Gbps x4  20Gbps   2.5usec   8/10 bit  16 Gbps
2008    QDR   Quadruple Data Rate  10Gbps x4  40Gbps   1.3 usec  8/10 bit  32 Gbps
2011    FDR   Fourteen Data Rate   14Gbps x4  56Gbps   0.7usec   64/66 bit 54.6 Gbps
2014    EDR   Enhanced Data Rate   25Gbps x4  100Gbps  0.5usec   64/66 bit    
~2017   HDR   High Data Rate       50Gbps x4  200Gbps           
~2020   NDR   Next Data Rate 
```

## Topology 

* Network Topologies:
  - **All-to-All** (Star) topologies provide non-blocking high bisection lo latency bandwidth between all (end)nodes. They are limited in scale to the switch port count.
  - **Fat-Tree** topologies provide (non-)blocking fabrics with consistent hop count, resulting in predictable latency. They do not scale linearly with cluster size.
  - **Torus** (Cube/Mesh) topologies add orthogonal dimensions of interconnect as they grow, thus can support very large clusters. Can be optimized for localized and/or global communication within the cluster. They are limited to x:1 blocking configurations. Simple wiring using shorter cables, and expandable without re-cabling. 
* Usually pyramid shaped topology, e.g. 2-Tier Fat Tree.
  - The switches at the top of the pyramid are called **Spines**/Core
  - The switches at the bottom of the Pyramid are called **Leafs**/Lines/Edges
  - **External connections** connect nodes to edge switches.
  - **Internal Connections** connect core with edge switches. 
* Non blocking (1:1) CLOS fabric, equal number of external and internal connections (balanced cross bisectional bandwidth)
* **Blocking** (x:1), external connections is higher than internal connections, over subscription

## Routes & Addresses

**Deterministic Distributed Routing** (usually) configured by Open Subnet Manager (OpenSM) which calculates and sends the **Linear Forwarding Table** (LFT) to the switches.

* Routes in determined algorithmically (SPF, MINHOP, FTREE, DOR, or LASH)
* Only one master SM allowed per subnet, can run on any node (or a managed switch)
* Discovers subnet topology (time depends on network scale) and scans for subnet changes
* Assigns **Local Identifiers** (LIDs) to all nodes
* Calculate and programs switch chip forwarding tables
* Subnet Manager Query Message: node & port information
* Subnet Manager Agent (SMA) required on each node

**Fabric Addressing**

* **GUID** Globally Unique Identifier
  - 64bit unique address assigned by vendor, persistent through reboot
  - 3 types of GUIDs: Node, port(, and system image)
* **LID** Local Identifier (48k unicast per subnet)
  - 16bit layer 2 address, assigned by the SM when port becomes active
  - Each HCA port has a LID; all switch ports share the same LID, director switches have one LID per ASIC
  - **LMC** LID Mask Controller, use multiple LIDs to load-balance traffic over multiple network paths
* **GID** Global Identifier
  - 128bit address unique across multiple subnets
  - Based on the port GUID combined with 64bit subnet prefix
  - Used in the Global Routing Header (GRH) (ignored by switches within a subnet)
* **PKEY** Partition Identifier
  - Fabric segmentation of nodes into different partitions
  - Partitions unaware of each other: limited `0` (can't communicate between them selfs) , full `1` membership
  - Ports may be member of multiple partitions
  - Assign by listing port GUIDs in `partitons.conf` 

```bash
ibstat                           # link state of the HCA, LIDs, GUIDs
       -d <card>                 # limit to card, e.g. mlx4_0
ibstatus                         # port GIDs
ibaddr
ibswitches                       # all switches, node GUIDs, number of ports, name
ibhosts                          # all channel adapters, node GUIDs, name
ibnodes                          # both of the above
iblinkinfo                       # all links: local LID, port (speed,state) -> remote LID, port, name
ibnetdiscover                    # all active ports 
```


[02]: https://www.openfabrics.org/
