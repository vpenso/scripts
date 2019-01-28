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
