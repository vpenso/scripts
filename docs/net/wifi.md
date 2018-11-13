# WiFI

```bash
nmcli radio wifi on|off       # toggle Wifi with NetworkManager
```

Identify the wireless driver (Linux kernel module):

```bash
iw                             # show wireless device configuration
lshw -C network                
lspci -nnk | grep -A2 0280     # use the PCI class code to find the wireless device
```

Configuration of the wireless driver (i.e. Intel ` iwlwifi`, broadcom `b43`)

```bash
modinfo -p M                   # configuration of kernel module M 
systool -av -m M               # ^^
/proc/cmdline                  # arguments from the kernel (on boot)
/etc/modprobe.d/*.conf         # module specific configuration files
```

### rfkill

The rfkill subsystem registers devices capable of transmitting RF (WiFi, Bluetooth, GPS, FM, NFC)

* **hard blocked** reflects some physical disablement
* **soft blocked** is a software mechanism to enable or disable transmission

```bash
rfkill list                    # current state
rfkill block all               # turn off all RF
rfkill unblock all             # turn on all RF
```

Hard block can not be unblocked by software:

* Check the BIOS for WiFi related settings
* Use the physical switch or a keyboard shortcut (typically using the `Fn` key)
* Multiple keys can exist i.e. one for WiFi and another one for Bluetooth

`rfkill` kernel module configuration (check with `modinfo -p rfkill`)

```bash
>>> cat /etc/modprobe.d/modprobe.conf
options rfkill master_switch_mode=2
options rfkill default_state=1
```
