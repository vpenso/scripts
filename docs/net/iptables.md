
Enable IP forwarding in the kernel:

```bash
# persistant configuration
>>> grep ^net.ipv4.ip_forward /etc/sysctl.conf && sysctl -p
net.ipv4.ip_forward=1
# enable with sysctl
sysctl -w net.ipv4.ip.forward=1
# or enable in /proc
echo 1 > /proc/sys/net/ipv4/ip/forward
```

# iptables

Packet filter framework in Linux:

* netfilter/xtables is the kernel-space component
* iptables is the user-space tool

## Rules

Properties of a **rule**:

* **Chain** it belongs to
* **Matches** classifying the desired packet characteristics 
* **Target** action to take if a packet matches, i.e. `ACCEPT`, `DROP`, `RETURN`, `REJECT` 

## Chains

Chains are collections of rules for packet filtering:

* Checked linearly (top to bottom)
* If no rule matches the default is applied
* Either built-in (i.e. INPUT) or user defined

| Chain       | Comment                                                  |
|-------------|----------------------------------------------------------|
| INPUT       | incoming packets terminating at localhost                |
| OUTPUT      | outgoing packets originating from localhost              |
| FORWARD     | packets not terminating or originating at/from localhost |
| PREROUTING  | packets traverse this chain before routing               |
| POSTROUTING | packets traverse this chain after routing                |

## Tables

Tables are collections of chains:

| Table  | Chains                                      | Comment                                      |
|--------|---------------------------------------------|----------------------------------------------|
| filter | INPUT,OUTPUT,FORWARD                        | (default) actual packet filtering            |
| nat    | PREROUTING,OUTPUT,POSTROUTING               | rewrite packet source/destination            |
| mangle | PREROUTING,INPUT,FORWARD,POSTROUTING,OUTPUT | alter packet headers/contents                |
| raw    |                                             | avoid connection tracking                    |

## Usage

Basic syntax for `iptables`:

    iptables <options> <chain> <matches> <target>

```bash
iptables -L -n                                      # view current rules
iptables -t filter --line-numbers -n --exact -v -L  # ^ in more details
iptables -L INPUT -n -v                             # show specific chain i.e. INPUT
iptables -t nat -L -v -n                            # show chain in the NAT table
iptables-save > ~/iptables.rules                    # store all rules in file
iptables-restore < ~/iptables.rules                 # restore rules from file
```

### Services

DNS (port 53):

```bash
## Accept outgoing traffic
iptables -A OUTPUT -p udp -o eth0 --dport 53 -j ACCEPT
iptables -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
```

SSH (port 22):

```bash
# outgoing
iptables -A OUTPUT -o eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
# incoming
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
# block logins after 3 failed attempts
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP
```

HTTP:

```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# better
iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
# redirect 80 to 8080
iptables -t nat -A OUTPUT -o lo -p tcp --dport 80 -j REDIRECT --to-port 8080
```

Mail:

```bash
# Accept SMTP/POP3 traffic
iptables -A INPUT -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 110 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 110 -m state --state ESTABLISHED -j ACCEPT
## disable outing mails
iptables -A OUTPUT -p tcp --dports 25,465,587 -j REJECT
```

### Sources & Destinations

Block incoming traffic:

```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -L -v -n
```

Drop ICMP traffic:

```bash
iptables -A OUTPUT -p icmp -j DROP
```

**IP address**

```bash
# accept incoming packets
iptables -A INPUT -s 1.2.3.4 -j ACCEPT       
# drop incoming packets
iptables -A INPUT -s 1.2.3.4 -j DROP
iptables -D INPUT -s 1.2.3.4 -j DROP          # unblock
iptables -A INPUT -p tcp -s 1.2.3.4 -j DROP   # specific protocol
iptables -A INPUT -s 1.2.3.4/24 -j DROP       # for an IP range
# reject outgoing connection for a specific port
iptables -A OUTPUT -p tcp --dport 1234 -s 1.2.3.4 -j REJECT
```

**Ports**

```bash
iptables -A INPUT -p tcp --dport 1234 -j ACCEPT               # allow incoming connections
iptables -A OUTPUT -p tcp --dport 1234 -j DROP                # block outgoing connections
iptables -A INPUT -p tcp -i eth0 -p tcp -dport 1234 -j DROP   # ^on selected interface
iptables -A INPUT -p tcp -s ! 1.2.3.4/24 -dport 1234 -j DROP  # ^except a specific IP range 
```

**MAC address**

```bash
iptables -A INPUT -m mac --mac-source 00:00:00:00:00:00 -j DROP
```

Sites

```bash
iptables -A OUTPUT -p tcp -d www.google.com -j DROP
iptables -A OUTPUT -p tcp -d goolge.com -j DROP
```


