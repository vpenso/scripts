
* **Router**: Forwards data packets between networks 
  - **Routing**: Select a path for traffic across multiple networks depending on the destination address
  - **Packet Forwarding**: Transit of network packets from one local network interface to another
* **Routing Table**: Lists the routes to particular network destinations
  - **Static Routes** a manually-configured routing rule
  - **Dynamic Routing** is based on a "discovery" procedure, e.g. a routing protocol like Spanning Tree
  - A routing **Entry** may have an associated **metric** (distance)
* **Route Evaluation Process** selects an entry from a routing table
  - Longest prefix match selects most specific entry with the longest subnet mask
* **Symmetric Routing**: Inbound and outbound traffic take the same path
* **Asymmetric Routing** should be avoided because:
  - Wrong interface source address may be considered as spoofed
  - State full firewalls depend on connection tracking of inbound and outbound traffic
  - Congestion off outbound traffic

```bash
routel                                               # list comprehensive routing configuration
ip r                                                 # show routing table
ip route get <address>                               # check which interface is used for a specific destination
ip route add <address>/<prefix> dev <interface>      # create network route
ip route add <address>/<prefix> via <gateway> dev <interace> # Static routes
ip route delete <address>/<prefix> dev <interface>   # remove network route
ip route flush cache                                 # flush routing cash after reconfiguration
ip route flush table main                            # empty routing table
## -- deprecated commands -- ##
netstat -rn                                          # show routing table
route -n
```

### Default Gateway

* Handles packages with destinations outside the local connected networks (by definition a router)
* **Default Route**: forwarding rule to use when no specific route can be determined
  - Designated zero-address `0.0.0.0/0` (IPv4) `::/0` (IPv6) 
  - `/0` subnet mask specifies all networks
  - Lookups not matching any other route use the default route

```bash
echo "1" > /proc/sys/net/ipv4/ip_forward             # Turn on IPv4 packet forwarding 
ip route add default via <ip>                        # configure/change the default route
ip route change default via <ip> dev <int>
ip route del default via <ip>                        # remove default gateway
## -- deprecated commands -- ##
route add default gw <ip>                            # add a default route
```

### Policy Routing

Policy-based routing allows routing decisions based on criteria other than the destination address.

* Uses a separate routing table for each of the interfaces
  - Policy rules direct outbound traffic to the appropriate routing table
  - Ensure that the `main` routing table has a default route
* Kernel search policy rules with lowest priority first
* `local` default ruleset with priority 0 matching _all_, handles traffic to localhost

```bash
ip rule                                                 # list routing tables
/etc/iproute2/rt_tables                                 # routing table configuration file
ip route show table <t_name>                            # show specific routing table
ip rule add from <ip> lookup <t_name> prio <num>        # add a routing policy to table
ip route add default via <ip> dev <dev> table <t_name>  # add a default route to table
```
