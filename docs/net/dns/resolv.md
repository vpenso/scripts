
DNS providers: 

* [Quad9](https://www.quad9.net)
* [OpenDNS](https://www.opendns.com/)
* [Google Public DNS](https://developers.google.com/speed/public-dns/)

**`/etc/resolv.conf`** configuration for the local resolution of domain names

```bash
nameserver 9.9.9.9                   # Quad9
nameserver 149.112.112.112
nameserver 208.67.222.222            # OpenDNS
nameserver 208.67.220.220
nameserver 8.8.8.8                   # Google
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
```

