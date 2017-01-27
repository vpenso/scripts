
→ [ib.md](ib.md)

# Computing Fabric

* Network of compute nodes interconnected with high-speed links
* Typically used in huge data-centers for IaaS and HPC
* **Switching Fabric**
  - Spread network traffic across multiple physical links (multipath)
  - Scalable fat-tree and mesh topologies 
  - More sophisticated routing to allow redundancy and high-throughput
  - Non-blocking (over-subscription) interconnect
  - Low latency layer 2-type connectivity

## Remote Direct Memory Access (RDMA)

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

