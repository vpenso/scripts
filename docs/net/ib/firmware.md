
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


