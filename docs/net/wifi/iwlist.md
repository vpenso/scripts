

`iwlist`, scans for available wireless networks, and display their configuration

```bash
# make sure the Wifi interface is up
dev=wlan0
ip link set $dev up
# scanning for nearby wireless access points
iwlist scan | egrep -i SSID\|Address\|Channel\|Quality\|Auth
```
