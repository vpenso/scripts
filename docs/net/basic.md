
# Devices

List Ethernet devices to acquire the PCI bus ID

    » lspci | grep -i ethernet
    02:00.0 Ethernet controller: […]

Read device information from sysfs

    » cat /sys/bus/pci/devices/0000:02:00.0/vendor    
    0x10ec

Find the vendor product number

    » grep 0x10ec /usr/src/linux-headers-$(uname -r)/include/linux/pci_ids.h
    #define PCI_VENDOR_ID_REALTEK           0x10ec

Configure Ethernet hardware with <kbd>ethtool</kbd>

    » ethtool eth0

Ethernet ARP table from <kbd>ip</kbd> ore <kbd>arp</kbd>:

    » ip n
    » arp -a

# Drivers

Identify the name of the driver module follow the link in the `/sys/class/net/*/device/driver`  sub-directory, here illustrated for the first Ethernet device `eth0`:

    » basename `readlink /sys/class/net/eth0/device/driver/module`
    tg3

You can find the kernel configuration parameter by searching in the Linux kernel source code, e.g.:

    » find -type f -name Makefile | xargs grep tg3
    ./drivers/net/ethernet/broadcom/Makefile:obj-$(CONFIG_TIGON3) += tg3.o
    » grep CONFIG_TIGON3 /boot/config-$(uname -r)
    CONFIG_TIGON3=m

List the system bus with <kbd>lspci</kbd>, and acquire the PCI device ID of the network device

    » lspci | grep -i ethernet
    05:00.0 Ethernet controller: Broadcom Corporation […]

Find the vendor product number from the PCI IDs kernel header:

    » cat /sys/bus/pci/devices/0000:05:00.0/vendor
    0x14e4
    » cat /sys/bus/pci/devices/0000:05:00.0/device
    0x1681
    » egrep "0x14e4|0x1681" include/linux/pci_ids.h 
    #define PCI_DEVICE_ID_AL_M1681          0x1681
    #define PCI_DEVICE_ID_MOXA_CP168U       0x1681
    #define PCI_VENDOR_ID_BROADCOM          0x14e4
    #define PCI_DEVICE_ID_TIGON3_5761       0x1681
    #define PCI_DEVICE_ID_ARECA_1681        0x1681

Search the kernel drivers source code directory for the vendor modules: 

    » grep -Rl PCI_VENDOR_ID_BROADCOM drivers/net/ethernet 
    drivers/net/ethernet/broadcom/tg3.c
    drivers/net/ethernet/broadcom/tg3.h
    drivers/net/ethernet/broadcom/b44.c
    drivers/net/ethernet/broadcom/bnx2.c

Get the details on a driver with <kbd>modinfo</kbd>: 

    » modinfo tg3
    filename:       /lib/modules/3.2.0-4-amd64/kernel/drivers/net/ethernet/broadcom/tg3.ko
    firmware:       tigon/tg3_tso5.bin
    firmware:       tigon/tg3_tso.bin
    firmware:       tigon/tg3.bin
    version:        3.121
    license:        GPL
    description:    Broadcom Tigon3 ethernet driver
    author:         David S. Miller (davem@redhat.com) and Jeff Garzik (jgarzik@pobox.com)
    […]



# Configuration

## DHCP

Use <kbd>dhcping</kbd> with the broadcast IP-address to determine if a DHCP server is on the network.

    » dhcping -s 255.255.255.255 -rv
    Got answer from: 10.1.2.3
    received from 10.1.2.3, expected from 255.255.255.255
    […]

Otherwise on a network without DHCP server. 

    » dhcping -s 255.255.255.255 -rv
    no answer

Inspect packages with <kbd>dhcpdump</kbd> 


## Networks


```bash
## -- CIDR blocks -- ##
Prefix  Netmask
/8      255.0.0.0     
/16     255.255.0.0   
/24     255.255.255.0  
## -- private IPv4 address ranges -- ##
First       Last            Class 
10.0.0.0    10.255.255.255  A     
172.16.0.0  172.31.255.255  B     
192.168.0.0 192.168.255.255 C     
```

```bash
ipcalc <address>/<prefix>                            # calculate sub networks
ipcalc <address> <netmask>
ip addr add <address>/<prefix> dev <interface>       # configure the IP address of a network interface:
ip addr show <interface>                             # show configuration for interface
ip link show up                                      # show enabled interfaces
ip link set <interface> up|down                      # enable/disable network interface
ip addr flush dev <interface>                        # clear interface IP configuration
/proc/net/dev                                        # network traffic counters
ip -s l                                              # ^^
```

## Sockets 

```bash
ss -l                                                # listening ports
netstat -lN
lsof -nPi tcp                                        # established connections
ss -r
netstat -p                                           # process socket binding:
ss -p
socklist
nc -vnzu <address> <port>                            # check connectivity to destination port
```
```bash
tcpdump -X -C NUM -i <interface>                     # listen to network traffic
tcpdump -i <interface> arp                           # ARP conversation
tcpdump -i <interface> port <port>                   # snoop ports
tcpdump -i <interface> dst <address> and port <port> # snoop a destination IP address
```



