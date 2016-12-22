
# Resolver

**`/etc/resolv.conf`** configuration for the local resolution of domain names

```bash
nameserver 208.67.222.222            # OpenDNS
nameserver 208.67.220.220
nameserver 8.8.8.8                   # Google Public DNS
nameserver 8.8.4.4
options timeout:1                    # seconds before query via a different name server
```

DNS resolution:

```bash
apt install -y dnsutils              # client DNS tool chain
dig +short @8.8.8.8 debian.org       # query a particular DNS server
host -t A debian.org 
dig +trace @8.8.8.8 debian.org       # track DNS resolution
```

**`resolvconf`** manages the resolver configuration

* Links `/etc/resolv.conf` to a dynamic configured `/etc/resolvconf/run/resolv.conf`

```bash
apt -y install resolvconf                  # install the package
zless /usr/share/doc/resolvconf/README.gz  # documentation
ls -1 /etc/resolvconf/resolv.conf.d/       # configuration
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/base
                                           # add a new DNS server (order matters)
resolvconf -u                              # update configuration after change
```

Disable NetworkManager DNS configuration in `/etc/NetworkManager/NetworkManager.conf` 

```bash
[Main]
dns=none
...
```

## DNSSEC

* Mechanism for including cryptographic signatures within the DNS resolution 
* Adds DNS Resource Records (RRs): 
  - `RRSIG` signature
  - `DNSKEY` primary key record for zone
  - `DS` key record fingerprint
  - `NSEC3`  sign negative responses
* Resolvers verify DNS resolution with with the root zone public key, IANA [Trust Anchors and Keys](https://www.iana.org/dnssec/files)

```bash
dig +trace <url> | grep -e RRSIG -e DS            # check for DNSSEC capability
dig org. SOA +dnssec @8.8.8.8 | grep ';; flags'   # ^ should return the "ad" flag
```

## Unbound

[Unbound](https://www.unbound.net/) caching DNS resolver including DNSSEC support

```bash
apt -y install unbound                            # install the packages
## -- adjust resolv.conf after installation --  ##
dig +dnssec debian.org @127.0.0.1                 # query the local DNS resolver
ls -1 /etc/unbound/unbound.conf.d/*.conf          # configuration files
unbound-control status                            # service state
unbound-anchor -l                                 # list trusted achor key
unbound-control get_option auto-trust-anchor-file # show location of tursted key
unbound-control list_stubs                        # list root servers in use
```

Enable the control interface:

```bash
>>> cat /etc/unbound/unbound.conf.d/control-interface.conf 
remote-control:
  control-enable: yes                                 # enable remote control
  control-interface: 127.0.0.1                        # interface listening for remote control
>>> unbound-control-setup                             # generate the necessary keys
>>> systemctl restart unbound                         # restart the service
```
```bash
unbound-control stats_noreset                         # print statistics without reset
unbound-control dump_cache                            # print chache
unbound-control reload                                # flush cache reload config
```
