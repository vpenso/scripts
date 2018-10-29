# IPVS

[Linux Virtual Server Project (LVS)][01], IPVS (IP Virtual Server):

* Layer 4 load balancing (aka layer 4 switching)
* TCP/UDP traffic load-balanced between physical servers
* Service exposed by a unique virtual IP
* Multiple ways to forward packages:
  - **NAT** (Network Address Translation)
  - **Direct Routing** (with an unmodified package) to a real server accepting traffic for a virtual IP address
  - **IP-IP Encapsulation** (tunnelling) forward/redirect packages to another address (possibly in a different network)


```bash
# install on CentOS
yum -y install ipvsadm
# enable IP forwarding
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf && sysctl -p
touch /etc/sysconfig/ipvsadm && systemctl enable --now ipvsadm
```

```bash
ipvsadm -L -n                    # show the number of active connections
ipvsadm -L -n --stats            # number of packets/bytes sent/received per second
ipvsadm -L -n --rate             # total number of packets/bytes sent/received
```

[01]: http://www.linuxvirtualserver.org/software/ipvs.html
