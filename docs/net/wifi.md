# WiFI

```bash
# ind wireless devices
lspci | egrep -i --color 'wifi|wlan|wireless'
# find the card(s) driver(s)
lspci | egrep -i --color 'wifi|wlan|wireless' \
      | cut -d' ' -f1 \
      | xargs lspci -k -s
# monitor link quality
watch -n 1 cat /proc/net/wireless
nmcli radio wifi on|off                 # toggle Wifi with NetworkManager
```

Bring a Wifi interface up i.e. `wlp3s0`

```bash
>>> dev=wlp3s0
>>> ip link set $dev up                     # bring the interface up
>>> ip link show $dev
#                                          ↓↓                                      
3: wlp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 10:bf:48:4c:33:f8 brd ff:ff:ff:ff:ff:ff
```

### iw

`iw` (replaced `iwconfig`) (no uspport for WPA/WPA2)

```bash
iw list                                 # show wireless device capabilities
iw dev $dev scan | grep -i ssid         # scan for wireless APs
iw dev $dev link                        # link connection status
```

### wpa_supplicant

Connect to an encrypted (WEP, WPA, WPA2) wireless network with [wpa_supplicant][wpa]:

[wpa]: http://w1.fi/wpa_supplicant/

```
# default configuration file
/etc/wpa_supplicant/wpa_supplicant.conf
# example config file
/usr/share/doc/wpa_supplicant/wpa_supplicant.conf
# generate config for AP connection (add it to the config file)
wpa_passphrase "$ssid"
```

Simple example configuration

```bash
ctrl_interface=/var/run/wpa_supplicant
network={
        ssid="..--WAVENET--.."
        psk=3dc0853c7be5c2d739d938481fbe18c25bd5435c1a783bdbccc2ba3d84a0e2e7
}
```

Start the service in background:

```bash
# AP specific configuration file
>>>file=/etc/wpa_supplicant/wavenet.conf
# start in background
>>> wpa_supplicant -B -c $file -i $dev
>>> ip link show $dev
#           ↓↓↓↓↓↓↓↓↓ 
3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DORMANT group default qlen 1000
    link/ether 10:bf:48:4c:33:f8 brd ff:ff:ff:ff:ff:ff
# query DHCP
dhcpcd $dev
```

### iwd

`iwd` (iNet wireless daemon) aims to replace WPA supplicant

- No external dependencies, base on kernel features
- Can be combinded with systemd-networkd

```bash
systemctl enable --now iwd           # start/enable service
iwctl device list                    # list wireless devices
iwctl device <dev> show              # show device details
iwctl station list                   # list state
iwctl station <dev> scan             # scan for networks
iwctl station <dev> get-networks     # list networks
iwctl station <dev> connect <ssid>   # connect to network
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
