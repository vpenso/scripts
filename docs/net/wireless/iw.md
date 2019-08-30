
`iw` (replaced `iwconfig`) (no support for WPA/WPA2)

```bash
iw list                                 # show wireless device capabilities
iw dev $dev scan | grep -i ssid         # scan for wireless APs
iw dev $dev link                        # link connection status
iw reg get                              # show regulatory domain
iw list | grep -A 15 Frequencies:       # query the number of available channels and their allowed transmit power
```

