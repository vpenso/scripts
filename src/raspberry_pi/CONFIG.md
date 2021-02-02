Default user `pi` password `raspberry`

## USB Gadget

Install DNS for local IP addresses and static services:

```shell
sudo apt install -y avahi-daemon avahi-discover libnss-mdns
```

Using an SD card with RaspberryPi OS:

```shell
pmount /dev/mmcblk0p1 && cd /media/mmcblk0p1
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
touch ssh
cp cmdline.txt cmdline.txt.org
# Look for rootwait, and add modules-load=dwc2,g_ether immediately after
cd && pumount /media/mmcblk0p1
```

```shell
>>> sudo dmesg
usb 1-1.2: new full-speed USB device number 12 using xhci_hcd
usb 1-1.2: new high-speed USB device number 13 using xhci_hcd
usb 1-1.2: New USB device found, idVendor=0525, idProduct=a4a2, bcdDevice= 5.04
usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.2: Product: RNDIS/Ethernet Gadget
usb 1-1.2: Manufacturer: Linux 5.4.83+ with 20980000.usb
cdc_ether 1-1.2:1.0 usb0: register 'cdc_ether' at usb-0000:00:14.0-1.2, CDC Ethernet Device, fe:d4:76:2e:6b:00
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver cdc_subset
cdc_ether 1-1.2:1.0 enxfed4762e6b00: renamed from usb0
>>> sudo journalctl -u avahi-daemon
```

Raspberry Pi Zero OTG Mode  
<https://gist.github.com/gbaman/50b6cca61dd1c3f88f41>
