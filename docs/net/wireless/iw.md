
`iw` (replaced `iwconfig`) (no support for WPA/WPA2)

```bash
iw list                                 # show wireless device capabilities
iw dev $dev scan | grep -i ssid         # scan for wireless APs
iw dev $dev link                        # link connection status
```

