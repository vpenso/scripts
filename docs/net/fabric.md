
### Network vs. Fabric 

* Network 
  - Designed as **universal interconnect**
  - Vendor interoperability by design (Ethernet)
  - All-to-all communication for any application
* Fabric
  - Designed as **optimized interconnect**
  - Single-vendor solution (Mellanox InfiniBand, Intel Omni-Path)
  - Single system build for a specific application
  - Performance & efficiency

### Offload vs. Onload

* **Onload**, network functions preformed by the host CPU (Ethernet, Omni-Path)
  - Manages network operations utilizing the CPU, hence decreasing resources available to applications 
* **Offload** network functions to the interconnect hardware (Infiniband)
  - _"Intelligent Network Devices"_
  - Network hardware performs communication operations (including data aggregation)
  - Increases resource availability of the CPU (improves overall efficiency)
* Comparison of Infiniband & Omni-Path¹
  - Message rate test (excluding overheat of data polling) to understand impact of network protocol on CPU utilization
  - Result: InfiniBand CPU resource utilization <1%, Omni-Path >50%

¹ Offloading vs. Onloading: The Case of CPU Utilization; Gilad Shainer (Mellanox), HPCWire
<https://www.hpcwire.com/2016/06/18/offloading-vs-onloading-case-cpu-utilization/>




# Network Fabric

* Network of compute nodes interconnected with high-speed links
* Typically used in huge data-centers for IaaS and HPC
* **Switching Fabric**
  - Spread network traffic across multiple physical links (multipath)
  - Scalable fat-tree and mesh topologies 
  - More sophisticated routing to allow redundancy and high-throughput
  - Non-blocking (over-subscription) interconnect
  - Low latency layer 2-type connectivity

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

