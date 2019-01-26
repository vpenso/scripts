## Resolver

The resolver routines in the C library are configured by `/etc/resolv.conf`

* If the file is missing DNS server on localhost is queried
* Configuration options:
  - `nameserver` - IP (ipv4/6) address of a name server
  - `domain` - Allows short names relative to the local domain
  - `search` - List for hostname lookups (space separated list of domains)
  - `options` - Modify the resolver mechanism (space separated list of options)
* The resolve library queries server in order listed

List of popular DNS providers:

```bash
# Quad 9
nameserver 9.9.9.9
nameserver 149.112.112.112
# OpenDNS
nameserver 208.67.222.222
nameserver 208.67.220.220
# Google
nameserver 8.8.8.8
nameserver 8.8.4.4
# CloudFlare
nameserver 1.1.1.1
nameserver 1.0.0.1
```

Some relevant options `options <opt1> <opt2>...` :

```bash
timeout:1                    # seconds before query via a different name server
rotate                       # round-robin selection of name servers
```

### NetworkManager

Disable NetworkManager DNS configuration in `/etc/NetworkManager/NetworkManager.conf` 

```bash
[Main]
dns=none
```

### Resolvconf

**`resolvconf`** manages the resolver configuration

Links `/etc/resolv.conf` to a dynamic configured `/etc/resolvconf/run/resolv.conf`

```bash
apt -y install resolvconf                  # install the package
zless /usr/share/doc/resolvconf/README.gz  # documentation
ls -1 /etc/resolvconf/resolv.conf.d/       # configuration
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/base
                                           # add a new DNS server (order matters)
resolvconf -u                              # update configuration after change
```

## Resolution

Install user-space commands for DNS resolution:

```bash
apt install -y dnsutils              # Debian
sudo pacman -Ss bind-tools           # Arch
```

The `host` command is the most simple to use:

```
host <domain>                # resolve IP address for a domain name
     <ip>                    # resolve a domain name of an IP address
     -C ...                  # SOA record                     
     -a ...                  # query of type ANY
```

Commands used for DNS resolution "lookup":

* `dig` uses the C resolver library
* `nslookup` uses an internal implementation for lookup (developed as part of ISC BIND)


```bash
dig +short @8.8.8.8 debian.org       # query a particular DNS server
host -t A debian.org 
dig +trace @8.8.8.8 debian.org       # track DNS resolution
```
