
Connect to an encrypted (WEP, WPA, WPA2) wireless network with [wpa_supplicant][wpa]:

[wpa]: http://w1.fi/wpa_supplicant/

```bash
# default configuration file
/etc/wpa_supplicant/wpa_supplicant.conf
# example config file
/usr/share/doc/wpa_supplicant/wpa_supplicant.conf
# generate config for AP connection (add it to the config file)
wpa_passphrase "$ssid"
```

Simple example configuration

```bash
# AP specific configuration file (evnetually called like the SSID)
>>> file=/etc/wpa_supplicant/wavenet.conf
>>> cat $file
ctrl_interface=/var/run/wpa_supplicant
network={
        ssid="..--WAVENET--.."
        psk=3dc0853c7be5c2d7...........
}
```

Start the WiFi access client in background and get an IP address from DHCP:

```bash
# start in background
>>> wpa_supplicant -B -c $file -i $dev
>>> ip link show $dev
#                                            ... and state should go ↓↓...
3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode ....
    link/ether 10:bf:48:4c:33:f8 brd ff:ff:ff:ff:ff:ff
# query DHCP for an IP-address
>>> dhcpcd $dev
>>> ip link show $dev
3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 10:bf:48:4c:33:f8 brd ff:ff:ff:ff:ff:ff
#        ↓↓↓↓↓↓↓↓↓↓↓ ... IP address should be visible
    inet 192.168.1.7/24 brd 192.168.1.255 scope global noprefixroute wlp3s0
       valid_lft forever preferred_lft forever
```
