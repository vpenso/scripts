# Ethernet

## Devices

Find Ethernet devices on the PCI/USB bus:

```bash
>>> grep -i ethernet <(lspci) <(lsusb) | cut -d: -f2-
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
Bus 002 Device 002: ID 0bda:8153 Realtek Semiconductor Corp. RTL8153 Gigabit Ethernet Adapter
# read PCI device information from sysfs
>>> cat /sys/bus/pci/devices/0000:02:00.0/vendor    
0x10ec
# find the vendor product number
>>> grep 0x10ec /usr/src/linux-headers-$(uname -r)/include/linux/pci_ids.h
#define PCI_VENDOR_ID_REALTEK           0x10ec
```

List all Ethernet **devices names**:

```bash
>>> ip -o link show | grep link/ether | cut -d: -f2 | sort
enp0s19f2u4
enp2s0
wlp3s0
>>> ls -1 /sys/class/net/ | egrep 'en|wl' | sort
enp0s19f2u4
enp2s0
wlp3s0
>>> cat /proc/net/dev | tail -n+4 | cut -d: -f1 | sort
enp0s19f2u4
enp2s0
wlp3s0
```

### Drivers

Identify the name of the driver module follow the link in `/sys/class/net/*/device/driver`

```
>>> basename `readlink /sys/class/net/eth0/device/driver/module`
tg3
# find kernel configuration parameter by searching in the Linux kernel source code
>>> find -type f -name Makefile | xargs grep tg3
./drivers/net/ethernet/broadcom/Makefile:obj-$(CONFIG_TIGON3) += tg3.o
>>> grep CONFIG_TIGON3 /boot/config-$(uname -r)
CONFIG_TIGON3=m
```

Find the vendor product number from the PCI IDs kernel header:

```
>>> cat /sys/bus/pci/devices/0000:05:00.0/vendor
0x14e4
>>> cat /sys/bus/pci/devices/0000:05:00.0/device
0x1681
>>> egrep "0x14e4|0x1681" include/linux/pci_ids.h 
#define PCI_DEVICE_ID_AL_M1681          0x1681
#define PCI_DEVICE_ID_MOXA_CP168U       0x1681
#define PCI_VENDOR_ID_BROADCOM          0x14e4
#define PCI_DEVICE_ID_TIGON3_5761       0x1681
#define PCI_DEVICE_ID_ARECA_1681        0x1681
```

Search the kernel drivers source code directory for the vendor modules: 

```
>>> grep -Rl PCI_VENDOR_ID_BROADCOM drivers/net/ethernet 
drivers/net/ethernet/broadcom/tg3.c
drivers/net/ethernet/broadcom/tg3.h
drivers/net/ethernet/broadcom/b44.c
drivers/net/ethernet/broadcom/bnx2.c
```

## Configuration


```bash
ethtool                             # NIC confgiuration utility
```

