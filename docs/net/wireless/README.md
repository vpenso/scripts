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
```

Bring a Wifi interface up i.e. `wlp3s0`

```bash
>>> dev=wlp3s0                              # interface name
>>> ip link set $dev up                     # bring the interface up
>>> ip link show $dev
#               ...the interface should go ↓↓ ...                                      
3: wlp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether 10:bf:48:4c:33:f8 brd ff:ff:ff:ff:ff:ff
```


## WiFi Deauthentication Reasons

```
Code 	Reason 	Explanation
0 	Reserved 	Normal working operation
1 	Unspecific Reason 	We don’t know what’s wrong
2 	Previous authentication no longer valid 	Client has associated but is not authorised.
3 	Deauthenticated because sending STA is leaving (or has left) IBSS or ESS 	The access point went offline, deauthenticating the client.
4 	Disassociated due to inactivity 	Client session timeout exceeded.
5 	Disassociated because AP is unable to handle all currently associated STAs 	The access point is busy, performing load balancing, for example.
6 	Class 2 frame received from nonauthenticated STA 	Client attempted to transfer data before it was authenticated.
7 	Class 3 frame received from nonassociated STA 	Client attempted to transfer data before it was associated.
8 	Disassociated because sending STA is leaving (or has left) BSS 	Operating System moved the client to another access point using non-aggressive load balancing.
9 	STA requesting (re)association is not authenticated with responding STA 	Client not authorized yet, still attempting to associate with an access point.
10 	Disassociated because the information in the Power Capability element is unacceptable
11 	Disassociated because the information in the Supported Channels element is unacceptable
12 	Reserved 	Not Used or Special Purpose
13 	Invalid information element.
14 	Message integrity code (MIC) failure
15 	4-Way Handshake timeout
16 	Group Key Handshake timeout
17 	Information element in 4-Way Handshake different from (Re)Association Request/Probe Response/Beacon frame
18 	Invalid group cipher or Association denied due to requesting STA not supporting all of the data rates in the BSSBasicRateSet parameter 	*NEW* The link speed requested by the client or AP is incompatible. (i,e. trying to operate N only speeds on a G AP)
19 	Invalid pairwise cipher
20 	Invalid AKMP
21 	Unsupported RSN information element version
22 	Invalid RSN information element capabilities
23 	IEEE 802.1X authentication failed
24 	Cipher suite rejected because of the security policy
25-31 	Reserved 	Not Used or Special Purpose
32 	Disassociated for unspecified, QoS-related reason 	Quality of Service has denied the action.
33 	Disassociated because QoS AP lacks sufficient bandwidth for this QoS STA
34 	Disassociated because excessive number of frames need to be acknowledged, but are not acknowledged due to AP transmissions and/or poor channel conditions
35 	Disassociated because STA is transmitting outside the limits of its TXOPs
36 	Requested from peer STA as the STA is leaving the BSS (or resetting)
37 	Requested from peer STA as it does not want to use the mechanism
38 	Requested from peer STA as the STA received frames using the mechanism for which a setup is required
39 	Requested from peer STA due to timeout
45 	Peer STA does not support the requested cipher suite
45-65 	Reserved 	Not Used or Special Purpose
99 		        Typically “No Reason Code” / Unknown State
535 	Reserved 	Not Used or Special Purpose
```

# References

[1] GNOME Network Manager  
https://wiki.gnome.org/Projects/NetworkManager/

[2] NetworkManager Gnome Applet  
https://gitlab.gnome.org/GNOME/network-manager-applet
