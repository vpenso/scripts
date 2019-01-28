# DHCP

Use `dhcping` with the broadcast IP-address to determine if a DHCP server is on the network.

```bash
>>> dhcping -s 255.255.255.255 -rv
Got answer from: 10.1.2.3
received from 10.1.2.3, expected from 255.255.255.255
# otherwise on a network without DHCP server. 
>>> dhcping -s 255.255.255.255 -rv
no answer
```

Inspect packages with `dhcpdump` 
