# Intel Omni-Path Architecture (OPA)

* Multi-lane, high-speed, low latency serial interconnect (copper & fiber)
  - Line speed: 100Gb/s (Link Rate)
* **HFI** (Host Fabric Interface)
  - Terminates fabric link, executes transport-level functions
  - cf. HCA (Infiniband)
* **FM** (Fabric Manager), cf. Subnet Manager (Infiniband)
* **OFI** (Open Fabric Interface) `libfabric`

## Link Transfer Layer

* Break from the traditional 7 layer OSI model
* In-between **Layer 1.5** providing a second layer of "packages" to enable **Single Link Control**
  - Error detection on the level of each link
* **FP** (Fabric Package) up to **10368bits** 
  - Data segmented into **FLITs** (Flow Control Digits)
  - FLIT `64bits + 1bit type = 65bits`
* **LTPs** (Link Transfer Packets) **1056bits**
  - Encapsulates up to `16x FLITs* = 1040bits`, plus 14bits CRC Checksum, plus 2bits VL credit 
  - May contain FLITs from multiple FPs
  - Request retransmission of LTPs on bit-errors
  - Efficiency equivalent to 64/66bit encoding (like FDR/EDR Infiniband)
* **VL** (Virtual Lanes), credit management
  - Up to 31 data VLs, plus 1 management VL
  - Receiver implements single buffer for all VLs
  - Transmitter manages shared buffer space dynamically to dedicated allocations for each VL
  - **Credit Return** 4 sequential LTPs return 8bit message
* **Traffic Flow Optimization**, FLITs on different VLs from different FPs can be interleaved into LTPs

## Routes

* Distributed switch based **Adaptive Routing**
  - Every switch analyzes congestion ⇒ adjusts routes
  - Balances bursts on top of consistent traffic
* **Dispersive Routing**
  - Probabilistic distribution of traffic, leverages multi-paths within fabric 
  - Traffic across multiple routes/virtual lanes
* Explicit **Congestion Notification Protocol**
  - Avoid _hot spots_ due to over-subscription



