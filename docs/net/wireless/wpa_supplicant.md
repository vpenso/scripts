
Connect to an encrypted (WEP, WPA, WPA2) wireless network with [wpa_supplicant][wpa]:

```bash
wpa_cli                            # used to configure wpa_supplicant
wpa_cli interface ${dev:-wlan0}    # select wireless interface
wpa_cli scan                       # scan for access points
wpa_cli scan_results               # list available access points
```

[wpa]: http://w1.fi/wpa_supplicant/

## configuration

```bash
/etc/wpa_supplicant/wpa_supplicant.conf             # default configuration file
/usr/share/doc/wpa_supplicant/wpa_supplicant.conf   # example config file
# configure the authentication with an AP
wpa_passphrase "$ssid" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf >/dev/null
# enter the password on the prompt
```

Configure the country code:

```bash
>>> grep country /etc/wpa_supplicant/wpa_supplicant.conf
country=DE
```

Reconfigure after a configuration change:

```bash
sudo wpa_cli -i ${dev:-wlan0} reconfigure
```

## Usage

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
