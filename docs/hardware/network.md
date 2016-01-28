
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

Common CIDR network masks 

| Suffix | Network Mask  |
|--------|---------------|
| /8     | 255.0.0.0     |
| /16    | 255.255.0.0   |
| /24    | 255.255.255.0 | 


Private IPv4 address ranges:

| First       | Last            | Class | 
|-------------|-----------------|-------|
| 10.0.0.0    | 10.255.255.255  | A     |
| 172.16.0.0  | 172.31.255.255  | B     |
| 192.168.0.0 | 192.168.255.255 | C     |

Calculate network IP address configuration with <kbd>ipcalc</kbd>:

    » ipcalc -b 10.0.0.8
    » ipcalc 10.0.3.0/16
    » ipcalc 10.0.3.0 255.255.0.0
      # Calculate multiple subnets
    » ipcalc 10.150.0.0/16 --s 25 25 50

## Addresses & Routes 


Configure the IP address of a network interface:

    » ip addr add 10.0.3.4/24 dev eth0

Show configuration for interface

    » ip addr show eth0

Show enabled interfaces

    » ip link show up

Enable/disable network interface

    » ip link set eth0 up|down

Clear interface IP configuration

    » ip addr flush dev eth0

Show routing table

    » ip r
    » ip route 
    » ip route list
    » ip route show table local

Check which interface is used for a specific destination

    » ip route get 192.169.4.5

Configure/change the default route

    » ip route add default via 192.168.1.1
    » ip route change default via 192.168.1.1 dev eth0 

Create network route

    » ip route add 192.168.1.0/24 dev eth0

Static routes

    » ip route add 192.168.55.0/24 via 192.168.1.254 dev eth1

Remove network route

     » ip route delete 192.168.1.0/24 dev eth0



# Operation

## Sockets/Ports

Listening ports:

    ss -l
    netstat -lN

Established connections:

    lsof -nPi tcp
    ss -r

Process socket binding:

    netstat -p
    ss -p
    socklist

Listen to network traffic:

    tcpdump -X -C NUM -i INTERFACE
    tcpdump -i eth0 arp
    tcpdump -i eth0 port 22
    tcpdump -i eth0 dst W.X.Y.Z and port 22

Check remote ports:

    » nc -vnzu 10.10.1.2 18000
    (UNKNOWN) [10.10.1.2] 18000 (?) open

## Counters

`/proc/net/dev` read **proc** man page.

List network counters (incoming & outgoing traffic) with <kbd>ip</kbd>
 
    » ip -s l
    » ip -stats link show

