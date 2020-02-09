

WiFi hardware needs to support the access point operation support:

```bash
>>> iw list 
...
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
...
```


## WiFi Link Layer

```bash
apt install -y hostapd
```

Configuration in `/etc/hostapd/hostapd.conf` (cf. [hostapd.conf][01]):

```bash
cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
driver=nl80211
ssid=..--2--..
country_code=DE
ieee80211d=1
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=test1234
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
wpa_group_rekey=86400
EOF
```

```bash
# run in foreground
hostapd /etc/hostapd/hostapd.conf
# start the service
systemctl unmask hostapd
systemctl enable --now hostapd
```

## IP Configuration

Static IP address assigned to the wireless port:

```bash
cat <<EOF | tee -a /etc/dhcpcd.conf
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF
systemctl restart dhcpcd
```

## DHCP Server

```bash
# install a DHCP server
apt install -y dnsmasqZ
# enable DHCP on the WiFi interface
cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF
# restart the DHCP server
systemctl restart dnsmasq
```

## Routing and Masquerade

```bash
cat > /etc/sysctl.d/05-ip-forward.conf <<EOF
net.ipv4.ip_forward=1
EOF
sysctl --system
# masquerade for outbound traffic on eth
iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
iptables-save > /etc/iptables.ipv4.nat
```

Edit `/etc/rc.local` and add this just above `exit 0`:

```bash
iptables-restore < /etc/iptables.ipv4.nat
```


[01]: https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
