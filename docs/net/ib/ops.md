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

## Install

Official Mellanox [Linux Drivers](http://www.mellanox.com/page/products_dyn?product_family=26&mtag=linux_sw_drivers)

Kernel drivers are required to operate the host channel adapter. 

CentOS:

```bash
yum install -y libibverbs librdmacm libibcm libibmad libibumad libmlx4 libmlx5 opensm ibutils infiniband-diags srptools perftest mstflint rdmacm-utils ibverbs-utils librdmacm-utils 
/etc/rdma/rdma.conf                      # configuration file
systemctl enable --now rdma.service      # enable Infinibnand
```

Debian

```bash
# jessie
apt install -y libmlx4-1 libibcommon1 libibmad1 libibumad1 libopensm2 infiniband-diags ibutils ofa-kernel-modules
```

## Kernel Modules

Mellanox HCAs require at least the `mlx?_core` and `mlx?_ib` kernel modules. 

* `mlx4_*` modules are use by **ConnectX** adapters, and `mlx5_*` modules are used by **Connect-IB** adapters.
* The "core" module is a generic driver use by `mlx_[ib|en|fc]` for Infiniband, Ethernet, or Fiber-Channel support.
* The "ib" module contains Infiniband specific functions.

```bash
## find all infiniband modules
>>> find /lib/modules/$(uname -r)/kernel/drivers/infiniband -type f -name \*.ko
## load requried modules
>>> for mod in mlx4_core mlx4_ib ib_umad ib_ipoib rdma_ucm ; do modprobe $mod ; done
## make sure modules get loaded on boot 
>>> for mod in mlx4_core mlx4_ib ib_umad ib_ipoib rdma_ucm ; do echo "$mod" >> /etc/modules-load.d/infiniband.conf ; done
## list loaded infiniband modules
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

