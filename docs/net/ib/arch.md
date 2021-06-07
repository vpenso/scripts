* InfiniBand Architecture (IBA)
  - Architecture for Interprocess Communication (IPC) networks
  - Switch-based, point-to-point interconnection network
  - low latency, high throughput, quality of service
  - CPU offload, hardware based transport protocol, bypass of the kernel
* [Mellanox Community](https://community.mellanox.com/)

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

SM monitors the fabric for a **topology changes**:

* **Light Sweep**, every 10sec require node/port information
  - Port status changes
  - Search for other SMs, change priority
* **Heavy Sweep** triggered by light sweep changes
  - Fabric discovery from scratch
  - Can be triggered by a IB TRAP from a status change on a switch
  - Edge/host port state change impact is configurable 
* SM **failover & handover** with SMInfo protocol 
  - Election by priority (0-15) and lower GUID
  - Heartbeat for stand-by SM polling the master
  - SMInfo attributes exchange information during discovery/polling to synchronize 

Only one master SM allowed per subnet, can run on any server

* Or a managed switch on small fabrics 650 nodes
* **Routeing Algorithm** (SPF, MINHOP, FTREE, DOR, or LASH) `opensm.conf`
  - **Min-Hop** minimal number of switch hops between nodes (cannot avoid credit loops)
  - **Up-Down** Min-Hop plus core/spine ranking (for non pure fat-tree topologies) [down-up routes not allowed] 
  - **ftree** congestion-free symmetric fat-tree, shift communication pattern

```bash
/etc/opensm/opensm.conf             # global configuration file
/var/cache/opensm/guid2lid
/var/log/opensm.log                 # SM logging
opensm -c /etc/opensm/opensm.conf   # create configuration file if missing
opensm -p <prio>                    # change priority of SM (when stopped!)
opensm -R <engine>                  # change routeing algorithem 
ibdiagnet -r                        # check for routing issues
sminfo                              # show master subnet manager LID, GUID, priority
smpquery portinfo <lid> <port>      # query port information
smpquery nodeinfo <lid>             # query node information
smpquery -D nodeinfo <lid>          # ^ using direct route
saquery -s                          # show all subnet managers
$IBDIAG/ibdiagnet*.sm               # SMs documented by ibdiagnet
ibroute <lid>                       # show switching table, LIDs in hex
```

Enable up-down routing engine:

```bash
>>> grep -e routing_engine -e root_guid_file /etc/opensm/opensm.conf    
#routing_engine (null)
routing_engine updn
#root_guid_file (null)
root_guid_file /etc/opensm/rootswitches.list
>>> head /etc/opensm/rootswitches.list
0xe41d2d0300e512c0
0xe41d2d0300e50bd0
0xe41d2d0300e51af0
0xe41d2d0300e52eb0
0xe41d2d0300e52e90
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
1999   SDR  Single Data Rate     2.5Gbps   x4 10Gbps   5usec     NRZ 
2004   DDR  Double Data Rate     5Gbps     x4 20Gbps   2.5usec   NRZ 8/10    16Gbps
2008   QDR  Quadruple Data Rate  10Gbps    x4 40Gbps   1.3usec   NRZ 8/10    32Gbps
2011   FDR  Fourteen Data Rate   14Gbps    x4 56Gbps   0.7usec   NRZ 64/66   54.6Gbps
2014   EDR  Enhanced Data Rate   25Gbps    x4 100Gbps  0.5usec   NRZ 64/66   96.97Gbps 
2017   HDR  High Data Rate       50Gbps    x4 200Gbps <0.5usec   PAM-4 
2021   NDR  Next Data Rate       100Gbps   x4 400Gbps            PAM-4
2023   XDR                       200Gbps   x4 800Gbps            PAM-4
       GDR                                    1.6Tbps
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



