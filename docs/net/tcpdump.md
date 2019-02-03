# tcpdump

Network debugging tool:

* Intercept/display packages transmitted/received on a network interface
* Filters used to select a subset of interesting packages
* Different output format for package typers


Options:

```bash
-D                    # list interfaces
-i <iface>            # select network interface
# output modifier
-t                    # not timestamps
-n                    # do not resolve hostname
-nn                   # ^^ and ports
-q                    # just source/destination
-v[v[v]]              # verbose output
-A                    # print payload (ASCII)
-x                    # ^^ in hex
-X                    # ^^ hex and ASCII
```

Filters, combine with `and` (`&&`), `or` ('||'), and `not` (`!`)

```
[src|dst] host <host>                       # packets from hostname/ip-address                 
gateway host <host>                         # packets using host as a gateway
[src|dst] net <cidr>                        # packeets from host in network, CIDR notation
[tcp|udp] [src|dst] port <port>             # packages send to/from port
                    portrange <port>-<port> # package in given port range
(ether|ip|ip6) proto <protocol>             # packages sinf via protocol
```

### Examples

Use IP addresses

```bash
# raw output stream
tcpdump -ttnnvvS | grep ...
# specific IP destination port
tcpdump -nnvvS src 192.168.1.10 and dst port 80
# traffic crossing between networks
tcpdump -nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16
# ICMP packages from a specific IP
tcpdump dst 192.168.0.2 and src net and not icmp
```

Specific protocols

```bash
# DHCP traffic
tcpdump -v -n port 67 or 68               
# SSH connections
tcpdump 'tcp[(tcp[12]>>2):4] = 0x5353482D'
# DNS traffic
tcpdump -vvAs0 port 53
# NTP traffic
tcpdump -vvAs0 port 123
# dumpo HTTPS traffic
tcpdump -nnSX port 443
```

Filter package content:

```
# extract HTTP reqeust URLs
tcpdump -s 0 -v -n -l | egrep -i "POST /|GET /|Host:"
# capture SMTP/POP3 email
tcpdump -nn -l port 25 | grep -i 'MAIL FROM\|RCPT TO'
# top host by package count
tcpdump -nnn -t -c 200 | cut -f 1,2,3,4 -d '.' | sort | uniq -c | sort -nr | head -n 20
```
