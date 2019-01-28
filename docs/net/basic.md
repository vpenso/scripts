

# Configuration

## DHCP

Use <kbd>dhcping</kbd> with the broadcast IP-address to determine if a DHCP server is on the network.

    » dhcping -s 255.255.255.255 -rv
    Got answer from: 10.1.2.3
    received from 10.1.2.3, expected from 255.255.255.255
    […]

Otherwise on a network without DHCP server. 

    » dhcping -s 255.255.255.255 -rv
    no answer

Inspect packages with <kbd>dhcpdump</kbd> 


## Networks


```bash
## -- CIDR blocks -- ##
Prefix  Netmask
/8      255.0.0.0     
/16     255.255.0.0   
/24     255.255.255.0  
## -- private IPv4 address ranges -- ##
First       Last            Class 
10.0.0.0    10.255.255.255  A     
172.16.0.0  172.31.255.255  B     
192.168.0.0 192.168.255.255 C     
```

```bash
ipcalc <address>/<prefix>                            # calculate sub networks
ipcalc <address> <netmask>
ip addr add <address>/<prefix> dev <interface>       # configure the IP address of a network interface:
ip addr show <interface>                             # show configuration for interface
ip link show up                                      # show enabled interfaces
ip link set <interface> up|down                      # enable/disable network interface
ip addr flush dev <interface>                        # clear interface IP configuration
/proc/net/dev                                        # network traffic counters
ip -s l                                              # ^^
```

## Sockets 

```bash
ss -l                                                # listening ports
netstat -lN
lsof -nPi tcp                                        # established connections
ss -r
netstat -p                                           # process socket binding:
ss -p
socklist
nc -vnzu <address> <port>                            # check connectivity to destination port
```
```bash
tcpdump -X -C NUM -i <interface>                     # listen to network traffic
tcpdump -i <interface> arp                           # ARP conversation
tcpdump -i <interface> port <port>                   # snoop ports
tcpdump -i <interface> dst <address> and port <port> # snoop a destination IP address
```



