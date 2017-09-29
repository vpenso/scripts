# Overview

* InfiniBand Architecture (IBA)
  - Architecture for Interprocess Communication (IPC) networks
  - Switch-based, point-to-point interconnection network 
  - low latency, high throughput, quality of service 
  - CPU offload, hardware based transport protocol, bypass of the kernel
* [Mellanox Community](https://community.mellanox.com/)

```bash
ibstat                           # link state of the HCA, LIDs, GUIDs
ibstat -d <card>                 # limit to card, e.g. mlx4_0
ibstatus                         # port GIDs
ibaddr
ibportstate                      # port configuration
ibv_devices                      # list HCS, GUIDs
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

```bash
ibswitches | cut -d' ' -f 2,10,5 | awk '{print $3,$1,$2}' | column -t
                                 # switch LIDs, GUIDs, description
smpquery -G switchinfo <guid>    # switch information by GUID
smpquery switchinfo <lid>        # switch information by LID
ibroute <lid>                    # show witch forwarding table
ibportstate <lid> <port>         # show link state of a given switch port
perfquery <lid> <port>           # show counters for a given switch port
```

## Kernel Modules

Kernel drivers are required to operate the host channel adapter. 

Mellanox HCAs require at least the `mlx?_core` and `mlx?_ib` kernel modules. 

* `mlx4_*` modules are use by **ConnectX** adapters, and `mlx5_*` modules are used by **Connect-IB** adapters.
* The "core" module is a generic driver use by `mlx_[ib|en|fc]` for Infiniband, Ethernet, or Fiber-Channel support.
* The "ib" module contains Infiniband specific functions.

```bash
## find all infiniband modules
>>> find /lib/modules/$(uname -r)/kernel/drivers/infiniband -type f -name \*.ko
## load requried modules
>>> for mod in mlx4_core mlx4_ib ib_umad ib_ipoib rdma_ucm ; do modprobe $mod ; done
## Add the module list to /etc/modules for boot persistence
>>> for mod in mlx4_core mlx4_ib ib_umad ib_ipoib rdma_ucm ; do echo "$mod" >> /etc/modules ; done
## listt loaded infiniband modules
>>> lsmod | egrep "^mlx|^ib|^rdma"
## check the version
>>> modinfo mlx4_core | grep -e ^filename -e ^version
## list module configuration parameters
>>> for i in /sys/module/mlx?_core/parameters/* ; do echo $i: $(cat $i); done
## module configuration
>>> cat /etc/modprobe.d/mlx4_core.conf
options mlx4_core log_num_mtt=20 log_mtts_per_seg=4
```

## IPoIB

IP over Infiniband (legacy applications)

* ARP over a specific multicast group to convert IP to IB addresses
* TCP/UDP over IPoIB  (IPv4/6)
  - TCP uses reliable-connected mode, MTU up to 65kb
  - UDP uses unreliable-datagram mode, MTU limited to IB packages side 4kb
* MTUs should be synchronized between all components

```bash
netstat -g                                # IP group membership
saquery -g | grep MGID | tr -s '..' | cut -d. -f2
                                          # list mulicast group GIDs
tail -n+1 /sys/class/net/ib*/mode         # connection mode
ibv_devinfo | grep _mtu                   # MTU of the hardware 
/sys/class/net/ib0/device/mlx4_port1_mtu
ip a | grep ib[0-9] | grep mtu | cut -d' ' -f2,4-5
                                          # MTU configuration for the interface
```

## BoIB

Boot over Infiniband (BoIB) is supported with adapter firmware >2.10, and FlexBoot (based on gPXE).

```bash
## Check the firmware version
>>> ibstat | grep Firmware
        Firmware version: 2.11.500
```

FlexBoot is an expansion ROM used to announce the Infiniband HCA to the BIOS as boot device. 

* Install or update this ROM using the Mellanox Firmware Tools. (see below)
* To boot over Infiniband using PXE enable the "MLNX FlexBoot" device in the BIOS boot order.

**The DHCP servers require to support Infiniband MACs/LIDs**

Use following commands to query for an DHCP lease using an Infiniband device. If the DHCP server doesn't support IB following error messages are presented:

```bash
>>> dhcping -i ib0 -V | grep answer
no answer
>>> dhclient -v
Internet Systems Consortium DHCP Client 4.2.2
[…]
Unsupported device type 32 for "ib0"
```

Mellanox FlexBoot iPXE support the use of an DHCP client identifier and/or a MAC address.

The dhcp-client-identifier is prefixed with a static part followed by an 8-byte port GUID:

* Extract the GUID with `ibstat` on a running system 
* Alternatively read the GUID from the iPXE boot-screen. 

```
|------------- prefix -------------|------ port GUID -----| 
ff:00:00:00:00:00:02:00:00:02:c9:00:00:25:90:ff:ff:f7:d2:05
```

MAC-addresses are determined from the GUID by removing the 2-bytes in the middle.

```
         GUID                     MAC 
00:25:90:ff:ff:f7:d2:05 >> 00:25:90:f7:d2:05
```

## Firmware

* **Mellanox Firmware Tools** (MFT), firmware management/debugging tools
  - Query firmware information, customize firmware images 
  - [MFT User Manual](http://www.mellanox.com/pdf/MFT/MFT_user_manual.pdf)
  - [Drivers](http://www.mellanox.com/supportdownloader/)
* `mst` **Mellanox Software Tools** (MST) service
  - Run `mst start` if not enabled
  - Creates special devices `/dev/mst/` interfacing the Mellanox devices
  - `mst save` writes PCI configuration headers to `var/mst_pci`
* **PSID** (Parameter-Set IDentification) of the channel adapter
  -  Mellanox PSIDs start with `MT_`. `SM_`, or `AS_` indicate vendor re-labeled cards
  - [Firmware](http://www.mellanox.com/page/firmware_download) using the PSID
* Components required to update the Firmware
  - Creating a custom **binary image** `.bin` file before flashing it to the cards Flash/EERPROM
  - Firmware binary images are created from a Mellanox firmware release in `.mlx` format
  - Card specific configuration in a **firmware parameter-set** `.ini` file

```bash
apt instal mstflint             # install tools on Debian
mst                             # MST service
mlxfwmanager                    # firmware query and update tool
flint                           # firmware burning tool
mlxconfig                       # change device configuration tool
mlxburn                         # firmware image generator and burner
mlxfwreset                      # firmware image generator 5th gen 
mlx_fpga                        # burner/debugger for FPGA devices
vendstat -N <lid>               # identify the hardware
```

Example of updating the firmware on Super Micro boards:

```bash
## -- List the device names
>>> mst start && mst status -v
DEVICE_TYPE             MST                           PCI       RDMA    NET                 NUMA  
ConnectX2(rev:b0)       /dev/mst/mt26428_pciconf0     
ConnectX2(rev:b0)       /dev/mst/mt26428_pci_cr0      02:00.0   mlx4_0  net-ib0  
## -- Backup the firmware from the device and save it as an binary image file
>>> mlxfwmanager --query | grep PSID
  PSID:             SM_2121000001000
>>> flint -d /dev/mst/mt26428_pci_cr0 ri SM_2121000001000.bin
>>> flint -i SM_2121000001000.bin q
FW Version:      2.7.700
[…]
PSID:            SM_2121000001000
## -- Dump a copy of the configuration parameter-set into an .ini file.
>>> flint -d /dev/mst/mt26428_pci_cr0 dc SM_2121000001000.ini
>>> egrep "Name|PSID" SM_2121000001000.ini
Name = H8DGT-(H)IBQ(F)
PSID = SM_2121000001000
[…]
## -- Use a new firmware release .mlx file, with a custom firmware parameter-set .ini file
>>> mlxburn -fw fw-ConnectX2-rel.mlx -conf SM_2121000001000.ini -wrimage SM_2121000001000-2.9.1000.bin
-I- Generating image ...
-I- Image generation completed successfully.
## -- Verify the integrety 
>>> flint -i SM_2121000001000-2.9.1000.bin v
## -- Burn it to the cards
>>> flint -d /dev/mst/mt26428_pci_cr0 -i SM_2121000001000-2.9.1000.bin burn
[…]
Burning FS2 FW image without signatures - OK  
Restoring signature                     - OK
```

### FlexBoot

Based on the iPXE and allows **Boot over Infiniband** (BoIB)

* Depending on the motherboard firmware enable "MLNX FlexBoot" as boot device, and adjust the boot order
* FlexBoot is deployed as expansion ROM image `.mrom` file 

```bash
## -- List firmware and PXE version
>>> mlxfwmanager --query
[…]
  Versions:         Current        Available     
     FW             2.30.8000      N/A           
     PXE            3.4.0225       N/A
## -- Burn a new expansion ROM
>>> flint -dev /dev/mst/mt26428_pci_cr0 brom FlexBoot-3.4.306_IB_26428.mrom
Burning ROM image    - OK  
Restoring signature  - OK
```

Following is an example iPXE configuration:

```bash
#!ipxe
set base http://mirror.centos.org/centos/7/os/x86_64
set ks http://server/path/to/kickstart
kernel ${base}/images/pxeboot/vmlinuz initrd=initrd.img inst.repo=${base} inst.text rd.shell rd.driver.post=mlx4_ib,ib_ipoib,ib_umad,rdma_ucm rd.neednet=1 rd.timeout=20 rd.retry=80 ip=${net0.dhcp/ip}::10.20.0.1:255.255.0.0:${net0.dhcp/hostname}.gsi.de:ib0:off nameserver=10.10.20.3 rd.route=10.20.0.0/16:10.20.0.1:ib0 ks.device=ib0 ks=${ks}/default.cfg
initrd ${base}/images/pxeboot/initrd.img
boot || goto shell
```

### Change MAC Address

* The IPoIB MAC addresses are derived from the Infiniband port GUIDs
  - `guid2mac(guid) is (((guid >> 16) & 0xffffff000000) | (guid & 0xffffff) )`
  - Remove the 2 middle bytes of an 8 bytes GUID to generate a 6 bytes MAC
* Use `flint` to change the MAC addresses by modifying the base GUID. 

```bash
>>> flint -d $(mst status | grep ^/dev/.*_cr | cut -d' ' -f1) query | grep -e ^Desc -e ^GUID
Description:     Node             Port1            Port2            Sys image
GUIDs:           0cc47affff37a9bc 0cc47affff37a9bd 0cc47affff37a9be 0cc47affff37a9bf
>>> flint -d /dev/mst/mt4099_pci_cr0 --guid 0x10c37be6fc120002 sg   
-W- GUIDs are already set, re-burning image with the new GUIDs ...
    You are about to change the Guids/Macs/Uids on the device:

                        New Values              Current Values
        Node  GUID:     10c37be6fc120000        10c37be6fc120002
        Port1 GUID:     10c37be6fc120001        10c37be6fc120003
        Port2 GUID:     10c37be6fc120002        10c37be6fc120004
        Sys.Image GUID: 10c37be6fc120003        10c37be6fc120005
        Port1 MAC:          10c37be6fc12            10c37be6fc12
        Port2 MAC:          10c37be6fc13            10c37be6fc13

 Do you want to continue ? (y/n) [n] : y
Burning FS2 FW image without signatures - OK  
Restoring signature                     - OK
## -- Similar for the Ethernet MAC address
>>> # flint -d /dev/mst/mt4099_pci_cr0 --mac 0x10c37be6fc12 sg
```


## Topology 

## Fat-Tree

**Fat-Tree** topologies provide (non-)blocking fabrics with consistent hop count, resulting in predictable latency. 
  - They do not scale linearly with cluster size (max. 7 layers/tiers)
  - The switches at the top of the pyramid shape are called **Spines**/Core
  - The switches at the bottom of the Pyramid are called **Leafs**/Lines/Edges
  - **External connections** connect nodes to edge switches.
  - **Internal Connections** connect core with edge switches. 

* **Constant Bisectional Bandwidth** (CBB)
  - Non blocking (1:1 ratio) 
  - Equal number of external and internal connections (balanced)
* **Blocking** (x:1), external connections is higher than internal connections, over subscription

## Torrus

**Torus** (Cube/Mesh) 3D topologies, CBB ratio 1:6

- Every switch node is connected to six neighbors
- Add orthogonal dimensions of interconnect as they grow
- Simple wiring using shorter cables, and expandable without re-cabling
- Can be optimized for localized and/or global communication within the cluster
- Requires routing engine to handle loops

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



