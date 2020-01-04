
Broken UAS support on ASMedia interfaces:

```bash
>>> dmesg
usb 3-2: Product: ASM105x
usb 3-2: Manufacturer: ASMT
usbcore: registered new interface driver usb-storage
scsi host2: uas
usbcore: registered new interface driver uas
scsi 2:0:0:0: Direct-Access     ASMT     2115             0    PQ: 0 ANSI: 6
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] 937703088 512-byte logical blocks: (480 GB/447 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: [sdb] tag#26 data cmplt err -71 uas-tag 1 inflight: CMD
sd 2:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 00 00 02 08 00 01 f8 00
usb 3-2: USB disconnect, device number 2
sd 2:0:0:0: [sdb] tag#26 uas_zap_pending 0 uas-tag 1 inflight: CMD
sd 2:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 00 00 02 08 00 01 f8 00
sd 2:0:0:0: [sdb] tag#26 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
sd 2:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 00 00 02 08 00 01 f8 00
```

```
# get the device ID
>>> lsusb | grep ASMedia
Bus 003 Device 065: ID 174c:55aa ASMedia Technology Inc. Name: ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge, ASM1153 SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge
```
```bash
echo "options usb_storage quirks=174c:55aa:u" >> /etc/modprobe.d/usb-storage-quirks.conf
update-initramfs -u
```

Reboot and attach the USB device:

```
>>> dmesg
...
usb 3-2: Product: ASM105x
usb 3-2: Manufacturer: ASMT
usb 3-2: SerialNumber: 00000000000000000000
usb 3-2: UAS is blacklisted for this device, using usb-storage instead
...
```
