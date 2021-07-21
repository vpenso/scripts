# systemd-resolved

Provides resolver services for DNS (DNSSEC, DNS over TLS)

```bash
systemctl enable --now systemd-resolved # start the service daemon
resolvectl status                       # check service status
/etc/systemd/resolved.conf              # conf. file
/etc/systemd/resolved.conf.d/*.conf     # drop-in conf. files
man resolved.conf                       # conf. file man-page
resolvectl query <ip|name>              # query DNS records
resolvectl statistics                   # show DNS cache stats
```

Fallback DNS addresses ensure DNS resolution in case no config is present

Provides a **local DNS stub** listener on IP address 127.0.0.53 on the local loopback interface:

```bash
rm /etc/resolv.conf
# redirect glibc NSS conf. file to local stub DNS resolver 
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
# operations mode detected automatically depending on existence of this link
```

### Configuration

Configure a custom list of DNS resolvers, and enable DNSSEC

```bash
mkdir /etc/systemd/resolved.conf.d
# use a drop in .conf file for the Quad9 primary DNS resolvers 
cat > /etc/systemd/resolved.conf.d/dns.conf <<EOF
[Resolve]
DNS=9.9.9.9 149.112.112.112
EOF
# if supported by the DNS resolvers, enforce DNSSEC validation
cat > /etc/systemd/resolved.conf.d/dnssec.conf <<EOF
[Resolve]
DNSSEC=true
EOF
# if supported by the DNS resolver, attempt to use DNS over TLS
cat > /etc/systemd/resolved.conf.d/dot.conf <<EOF
[Resolve]
DNSOverTLS=opportunistic
EOF
```

systemd-resolved currently only supports `opportunistic` DNS over TLS resolution

- Resolver tries resolution using DoT before fall back to traditional DNS (allowing for downgrade attacks)
- Eventually another option will be added `strict` to prevent fallback

DNS server certificates are not checked making systemd-resolved vulnerable to man-in-the-middle attacks

### Debugging

Enable debugging and follow the logs:

```bash
resolvectl log-level debug             
journalctl -fu systemd-resolved
# disable debugging
resolvectl log-level info
```
