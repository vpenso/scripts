## Single root I/O virtualization (SR-IOV)

PCI Special Interest Group (PCI-SIG) specification for I/O virtualization.

* Extension to the PCI Express (PCIe) specification
* Allows partitioning of a PCI function into many virtual interfaces for the 
  purpose of sharing the resources of a PCIe device in a virtual environment

Enables PCIe **adapter sharing for virtual machines and containers**.

* PCIe adapters become self-virtualizing, a single PCIe device appears as 
  **multiple, separate devices**
  - The physical device is referred to as **Physical Function** (PF)
  - Virtual devices are referred to as **Virtual Functions** (VF)
* By default, SR-IOV is disabled and the PF behaves as a regular PCIe device

Physical function:

* Function of a PCIe adapter that supports the SR-IOV interface, advertises by 
  the device's SR-IOV capabilities
* Used to **dynamically allocate VFs** controlled by the PF via registers 
  encapsulated in the capability
* The max. number of VFs limited by the device hardware (up to 256 acc. to spec.)
* Typical supports L2 sorter/switcher, link controls

Virtual function:

* Each VF's PCI configuration space can be accessed by...
  - its own bus, slot and function number (Routing ID)
  - a PCI memory space, which is used to map its register set
* Can move data in and out of DMA
* Dedicated Tx/Rx queues

SR-IOV drivers are implemented in the Linux kernel:

* VFs have near-native performance (better performance than para-virtualized 
  drivers and emulated access)
* VFs provide data protection between partitions (including Quality of Service) 
