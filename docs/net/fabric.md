
# Interconnect

* **HPI** (High Performance Interconnect)
  - Equipment designed for very high bandwidth and extreme low latency
  - Inter-node communication supporting large (node counts) clusters
* Technologies in the HPI market:
  - Ethernet, RoCE (RDMA over Converged Ethernet)
  - InfiniBand → [ib.md](ib.md)
  - Intel Omni-Path → [opa.md](opa.md)
  - Cray Aries XC
  - SGI NUMALink
* HPI evaluation criteria
  - Reliability of inter-node communication
  - Maximum requirements on link bandwidth
  - Sufficiently low latency
  - Load on node CPUs by the communication stack
  - TcO of the equipment in relation to overall performance

## Network vs. Fabric 

* Network 
  - Designed as **universal interconnect**
  - Vendor interoperability by design (Ethernet)
  - All-to-all communication for any application
* Fabric
  - Designed as **optimized interconnect**
  - Single-vendor solution (Mellanox InfiniBand, Intel Omni-Path)
  - Single system build for a specific application
  - Spread network traffic across multiple physical links (multipath)
  - Scalable fat-tree and mesh topologies 
  - More sophisticated routing to allow redundancy and high-throughput
  - Non-blocking (over-subscription) interconnect
  - Low latency layer 2-type connectivity

## Offload vs. Onload

* Network functions performed mostly in software "**onload**" (Ethernet, Omni-Path)
  - Requires CPU resources ⇒ _decreases cycles available_ to hosted applications
* Network functions performed by hardware "**offload**" (Infiniband, RoCE), aka _Intelligent Interconnect_
  - Network hardware performs communication operations (including data aggregation)
  - Increases resource availability of the CPU (improves overall efficiency)
  - Particularly advantageous in scatter,gather type collective problems
* Trade-off
  - More capable network infrastructure (offload) vs. incrementally more CPUs on servers (onload)
  - Advantage of offloading increases with the size of the interconnected clusters (higher node count = more messaging)
* Comparison of Infiniband & Omni-Path¹
  - Message rate test (excluding overheat of data polling) to understand impact of network protocol on CPU utilization
  - Result: InfiniBand CPU resource utilization <1%, Omni-Path >40%


## Ethernet vs. Infiniband vs. Omni-Path

* Ethernet 10/25/40/50/100G (200G in 2018/19)
  - Widely in production, supported by many manufacturers (Cisco, Brocade, Juniper, etc.)
  - Easy to deploy, widespread expert knowledge
  - "High" latency (ms rather than ns)
* InfiniBand 40/56/100G (200G 2017)
  - Widely used in HPC, cf. TOP500
  - De-facto lead by Mellanox
* Omni-Path 100G (future roadmap?)
  - Intel proprietary
  - Still in its infancy (very few production installations)
  - Claims better bandwidth/latency/message rate then InfiniBand

## Application Interface

* [OpenFabrics](https://www.openfabrics.org/) Alliance (OFA) 
  - Builds open-source software: **OFED** (OpenFabrics Enterprise Distribution)
  - Kernel-level drivers, channel-oriented RDMA and send/receive operations
  - Kernel and user-level application programming interface (API) 
  - Services for parallel message passing (MPI)
  - Includes Open Subnet Manager with diagnostic tools
  - IP over Infiniband (IPoIB), Infiniband Verbs/API

### Remote Direct Memory Access (RDMA)

* Linux kernel network stack limitations
  - System call API package rates to slow for high speed network fabrics with latency in the nano-seconds 
  - Overhead copying data from user- to kernel-space
  - Workarounds: Package aggregation, flow steering, pass NIC to user-space...
* **RDMA Subsystem**: Bypass the kernel network stack to sustain full throughput
  - Special **Verbs** library maps devices into user-space to allow direct data stream control
  - Direct user-space to user-space memory data transfer (zero-copy)
  - Offload of network functionality to the hardware device
  - Messaging protocols implemented in RDMA
  - Regular network tools may not work
  - Bridging between common Ethernet networks and HPC network fabrics difficult
* Protocols implementing RDMA: Infiniband, Omnipath, Ethernet(RoCE)
* Future integration with the kernel network stack?
  - Integrate RDMA subsystem messaging with the kernel
  - Add Queue Pairs (QPs) concept to the kernel network stack to enable RDMA
  - Implement POSIX network semantics for Infiniband

### RDMA over Converged Ethernet

* Advances in Ethernet technology allows to build "lossless" Ethernet fabrics
  - **PFC** (Priority-based Flow Control) prevents package loss due to buffer overflow at switches
  - Enables **FCoE** (Fibre Channel over Ethernet), **RoCE** (RDMA over Converged Ethernet)
  - Ethernet NICs come with a variety of options for offloading
* RoCE specification supported as annex to the IBTA
* Implements Infiniband Verbs over Ethernet (OFED >1.5.1)
  - Use Infiniband transport & network layer, swaps link layer to use Ethernet frames
  - IPv4/6 addresses set over the regular Ethernet NIC
  - Control path RDMA-CM API, data path Verbs API

### OpenFabrics Interfaces (OFI)

* Developed by the OFI Working Group, a subgroup of OFA
  - Successor to IB Verbs, and RoCE specification
  - Optimizes software to hardware path by minimizing cache and memory footprint
  - Application-Centric and fabric implementation agnostic
* [libfabric](https://ofiwg.github.io/libfabric/) core component of OFI
  - User-space API mapping applications to underlying fabric services
  - Hardware/protocol agnostic
* Fabric hardware support implemented in **OFI providers**
  - Socket provider for development
  - Verbs provides allows to run over hardware supporting `libibverbs` (Infiniband)
  - `useNIC` (user-space NIC) providers supports Cisco Ethernet hardware
  - PSM (Performance Scale Messaging) provider for Intel Omni-Path and Cray Aries 

# Reference

¹ Offloading vs. Onloading: The Case of CPU Utilization; Gilad Shainer (Mellanox)  
<https://www.hpcwire.com/2016/06/18/offloading-vs-onloading-case-cpu-utilization/>

² The Ultimate Debate – Interconnect Offloading Versus Onloading, Gilad Shainer (2016/04)  
<https://www.hpcwire.com/2016/04/12/interconnect-offloading-versus-onloading/>

³ The Interplay of HPC Interconnects and CPU Utilization, Gilad Shainer (2017/01)  
<https://www.nextplatform.com/2017/01/13/interplay-hpc-interconnects-cpu-utilization/>

⁴ Comparison of 40G RDMA and Traditional Ethernet Technology, Nichole Boscia, Harjot S. Sidhu (NASA, 2014/01)  
<https://www.nas.nasa.gov/assets/pdf/papers/NAS_Technical_Report_NAS-2014-01.pdf>

⁵ RDMA over Commodity Ethernet at Scale, Chuanxiong Guo (Microsoft, 2016)  
<http://research.microsoft.com/en-us/um/people/padhye/publications/sigcomm2016-rdma.pdf>
