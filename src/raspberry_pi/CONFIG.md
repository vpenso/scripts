Default user `pi` password `raspberry`

## USB Gadget

Using an SD card with Raspberry Pi OS:

```shell
# mount the boot partition
pmount /dev/mmcblk0p1 && cd /media/mmcblk0p1
# add the OTG driver
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
# enable SSH in a headless setup
touch ssh
vi cmdline.txt # Look for rootwait, and add modules-load=dwc2,g_ether immediately after
cd && pumount /media/mmcblk0p1
```

### Virtual Ethernet

The `g_ether` modules able virtual Ethernet point to point networking.

On the host computer:

```
dmesg | grep cdc_ether    # renames the interface to enx*
# interface name and mac-address
ip -o link | grep enx | awk '{print $2, $17}'
```

Assign an IP address to the interface `enx*`:

```shell
iface=$(ip -o link | grep enx | awk '{print $2}' | tr -d ':')
ip a add 192.168.7.1/24 dev $iface
ip link set dev $iface up
```

```
echo 'MulticastDNS=yes' > /etc/systemd/resolved.conf.d/mdns.conf
systemctl restart systemd-resolved
systemd-resolve --set-mdns=yes --interface=usb0 \
        && systemd-resolve --status usb0
```

### Serial Console

The `g_serial` module enables serial console on a connected computer:

```
sudo modprobe g_serial
sudo systemctl start getty@ttyGS0.service
```

# References

Raspberry Pi Zero OTG Mode  
<https://gist.github.com/gbaman/50b6cca61dd1c3f88f41>

Raspberry Pi Console over USB: Configuring an Ethernet Gadget  
<https://shallowsky.com/blog/linux/raspberry-pi-ethernet-gadget.html>  
<https://shallowsky.com/blog/linux/raspberry-pi-ethernet-gadget-2.html>  
<https://shallowsky.com/blog/linux/raspberry-pi-ethernet-gadget-3.html>
