
```bash
lspci | egrep -i --color 'wifi|wlan|wireless'    # Find wireless devices
# find the card(s) driver(s)
lspci | egrep -i --color 'wifi|wlan|wireless' \
      | cut -d' ' -f1 \
      | xargs lspci -k -s
watch -n 1 cat /proc/net/wireless                # monitor link quality
ip link set ${dev:-wlan0} up                     # bring the interface up
```


