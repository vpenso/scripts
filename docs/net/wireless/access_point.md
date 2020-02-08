

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

[01]: https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
