
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



