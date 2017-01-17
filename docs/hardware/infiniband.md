```bash
ibstat                           # link state of the HCA, LIDs, GUIDs
ibstat -d <card>                 # limit to card, e.g. mlx4_0
ibstatus                         # port GIDs
ibaddr
ibportstate                      # port configuration
ibv_devices                      # list HCS, GUIDs
ibswitches                       # all switches, node GUIDs, number of ports, name
ibhosts                          # all channel adapters, node GUIDs, name
ibnodes                          # both of the above
iblinkinfo                       # all links: local LID, port (speed,state) -> remote LID, port, name
ibnetdiscover                    # all active ports
ibtracert <lid> <lid>            # trace route between nodes
## measure latency ##
ibping -S                        # start server
ibping -L <lid>                  # ping the server
## measure performance ##
ib_rdma_lat                      # tests the latency between two nodes
ib_rdma_bw                       # test the bandwidth
ibdump -d <card>                 # capture traffic to file (use Wireshark tool)
```

# Overview

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

## Addresses

* **GUID** Globally Unique Identifier
  - 64bit unique address assigned by vendor, persistent through reboot
  - 3 types of GUIDs: Node, port(, and system image)
* **LID** Local Identifier (48k unicast per subnet)
  - 16bit layer 2 address, assigned by the SM when port becomes active
  - Each HCA port has a LID; all switch ports share the same LID, director switches have one LID per ASIC
* **GID** Global Identifier
  - 128bit address unique across multiple subnets
  - Based on the port GUID combined with 64bit subnet prefix
  - Used in the Global Routing Header (GRH) (ignored by switches within a subnet)
* **PKEY** Partition Identifier
  - Fabric segmentation of nodes into different partitions
  - Partitions unaware of each other: limited `0` (can't communicate between them selfs) , full `1` membership
  - Ports may be member of multiple partitions
  - Assign by listing port GUIDs in `partitons.conf` 

## Routes

Fabric Initialization by the **Subnet Manager** (SM)

1. Subnet Discovery (after SM wakeup)
  - Travers the network beginning with close neighbors
  - Subnet Manager Packages (SMP) to initiate "conversation" 
2. Information Gathering
  - Find all links/switches/hosts on all connected ports to map topology
  - Subnet Manager Query Message: direct routed information gathering for node/port information
  - Subnet Manager Agent (SMA) required on each node
3. LIDs assignment
4. Paths establishment
   - Best path calculation to identify **Shortest Path Table** (Min-Hop)
   - Calculate **Linear Forwarding Table** (LFP) 
5. Ports and Switch configuration
6. Subnet Activation

Only one master SM allowed per subnet, can run on any node (or a managed switch)

* Routes determined algorithmically (SPF, MINHOP, FTREE, DOR, or LASH) `opensm.conf`
  - **Min-Hop** minimal number of switch hops between nodes (cannot avoid credit loops)
  - **Up-Down** Min-Hop plus core/spine ranking (for non pure fat-tree topologies)
  - **ftree** congestion-free symmetric fat-tree

SM monitors the fabric for a topology changes:

* **Light Sweep**, every 10sec require node/port information
  - Port status changes
  - Search for other SMs, change priority
* **Heavy Sweep** triggered by light sweep changes
  - Fabric discovery from scratch
  - Can be triggered by a IB TRAP from a status change on a switch
  - Edge/host port state change impact is configurable 
* SM failover & handover with SMInfo protocol 
  - Election by priority (0-15) and lower GUID
  - Heartbeat for stand-by SM polling the master
  - SMInfo attributes exchange information during discovery/polling to synchronize 

```bash
sminfo                           # show master subnet manager LID, GUID, priority
smpquery portinfo <lid> <port>   # query port information
smpquery nodeinfo <lid>          # query node information
smpquery -D nodeinfo <lid>       # ^ using direct route
saquery -s                       # show all subnet managers
ibroute <lid>                    # show switching table, LIDs in hex
```

## Layers

### Physical Layer

* Link Speed x Link Width = Link Rate
* Bit Error Rate (BER) 10^15
* **Virtual Lane** (VL), multiple virtual links on single physical link
  - Mellanox 0-7 VLs each with dedicated buffers 
  - Quality of Service, bandwidth management
* Media for connecting two nodes
  - Passive Copper Cables FDR max. 3m, EDR max. 2m
  - Active Optical Cables (AOCs) FDR max. 300m, EDR max. 100m
  - Connector QSFP

```
            Speed                       Width Rate     Latency   Encoding    Eff.Speed
---------------------------------------------------------------------------------------
1999   SDR  Single Data Rate     2.5Gbps   x4 10Gbps   5usec        
2004   DDR  Double Data Rate     5Gbps     x4 20Gbps   2.5usec   8/10 bit    16Gbps
2008   QDR  Quadruple Data Rate  10Gbps    x4 40Gbps   1.3usec   8/10 bit    32Gbps
2011   FDR  Fourteen Data Rate   14Gbps    x4 56Gbps   0.7usec   64/66 bit   54.6Gbps
2014   EDR  Enhanced Data Rate   25Gbps    x4 100Gbps  0.5usec   64/66 bit   96.97Gbps 
2017   HDR  High Data Rate       50Gbps    x4 200Gbps <0.5usec            
~2020  NDR  Next Data Rate 
```

### Link Layer

* Subnet may contain: 48K unicast & 16k multicast addresses
* **Local Routing Header** (LRH) includes 16bit Destination LID (DLID) and port number
* **LID Mask Controller** (LMC), use multiple LIDs to load-balance traffic over multiple network paths
* **Credit Based Flow Control** between two nodes
  - Independent for each virtual lane (to separate congestion/latency)
  - Sender limited by credits granted by the receiver in 64byte units
* **Service Level** (SL) to Virtual Lane (VL) mapping defined in `opensm.conf`
  - Priority & weight value 0-255 indicate number 64byte units transported by a VL
  - Guarantee performance to data flow to provide QoS
* Data Integrity
  - 16bit Variant CRC (VCRC) link level integrity between two hops 
  - 32bit Invariant CRC (ICRC) end-to-end integrity
* Link Layer Retransmission (LLR) 
  - Mellanox SwitchX only, up to FDR, enabled by default
  - Recovers problems on the physical layer
  - Slight increase in latency
  - Should remove all symbol errors
* Forward Error Correction (FEC)
  - Mellanox Switch-IB only, EDR forward
  - Based on 64/66bit encoding error correction 
  - No bandwidth loss

### Network Layer

* Infiniband Routing
  - Fault isolation (e.g topology changes)
  - Increase security (limit attack scope within a network segment)
  - Inter-subnet package routing (connect multiple topologies)
* Uses GIDs for each port included in the **Global Routing Header** (GRH)
* Mellanox Infiniband Router SB7788 (up to 6 subnets)

### Transport Layer

* Message segmentation into multiple packages by the sender, reassembly on the receiver
  - **Maximum Transfer Unit** (MTU) default 4096 Byte `openib.conf`
* End-to-End communication service for applications **Virtual Channel**
* **Queue Pairs** (QPs), dedicated per connection
  - Send/receive queue structure to enable application to bypass kernel
  - Mode: connected vs. datagram; reliable vs. unreliable
  - Datagram mode uses one QP for multiple connections
  - Identified by 24bit Queue Pair Number (QPN)

### Upper Layer

* Protocols
  - Native Infiniband RDMA Protocols
  - MPI, RDMA Storage (iSER, SRP, NFS-RDMA), SDP (Socket Direct), RDS (Reliable Datagram)
  - Legacy TCP/IP, transported by IPoIB
* Software transport **Verbs** 
  - Client interface to the transport layer, HCA
  - Most common implementation is OFED
* Subnet Manager Interface (SMI)
  - Subnet Manager Packages (SMP) (on `QP0 VL15`, no flow control)
  - LID routed or direct routed (before fabric initialisation using port numbers) 
* General Service Interface (GSI)
  - General Management Packages (GMP) (on `QP1`, subject to flow control)
  - LID routed


[02]: https://www.openfabrics.org/
