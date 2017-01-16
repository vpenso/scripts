# Infiniband

* InfiniBand Architecture (IBA)
  - Architecture for Interprocess Communication (IPC) networks
  - Switch-based, point-to-point interconnection network 
  - low latency, high throughput, quality of service 
  - CPU offload, hardware based transport protocol, bypass of the kernel
* [OpenFabrics][02] Alliance (OFA) builds OpenFabrics Enterprise Distribution (OFED)
  - Kernel-level drivers, channel-oriented RDMA and send/receive operations,
  - Kernel and user-level application programming interface (API) and services for parallel message passing (MPI)

Data rates:

```
1999    SDR   Single Data Rate   2.5 Gbps x 4  10 Gbps   5usec        
2004    DDR   Double Data Rate     5 Gbps x 4  20 Gbps   2.5usec   8/10 bit  16 Gbps
2008    QDR   Quadruple Data Rate 10 Gbps x 4  40 Gbps   1.3 usec  8/10 bit  32 Gbps
2011    FDR   Fourteen Data Rate  14 Gbps x 4  56 Gbps   0.7usec   64/66 bit 54.6 Gbps
2014    EDR   Enhanced Data Rate  25 Gbps x 4  100 Gbps  0.5usec   64/66 bit    
~2017   HDR   High Data Rate      50 Gbps x 4  200 Gbps           
~2020   NDR   Next Data Rate 
```

## Routes & Addresses

**Deterministic Distributed Routing** (usually) configured by Open Subnet Manager (OpenSM) which calculates and sends the **Linear Forwarding Table** (LFT) to the switches.

* Only one master SM allowed per subnet, can run on any node (or a managed switch)
* Discovers subnet topology (time depends on network scale) and monitors changes in the subnet
* Assigns volatile **Local Identifiers** (LIDs) to all devices
* Calculate and programs switch chip forwarding tables
* Routes in determined algorithmically (SPF, MINHOP, FTREE, DOR, or LASH) 
* Subnet Manager Query Message: node & port information

**Fabric Addressing**

* **GUID** Globally Unique Identifier
  - 64bit unique address assigned by vendor, persistent through reboot
  - 3 types of GUIDs: Node, port, and system
* **LID** Local Identifier
  - 16bit layer 2 address, assigned by the SM when port becomes active (not persistent)
  - Each HCA port has a LID; all switch ports share the same LID, director switches have one LID per ASIC
* **GID** Global Identifier
  - 128bit address unique across multiple subnets
  - Based on GUID combined with subnet prefix
  - Used in the Global Routing Header (GRH) (ignored by switches within a subnet)

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


[02]: https://www.openfabrics.org/
