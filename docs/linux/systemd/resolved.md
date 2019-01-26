# systemd-resolved

Provides resolver services for DNS (DNSSEC, DNS over TLS)

```bash
systemctl enable --now systemd-resolved # start the service daemon
resolvectl status                       # check service status
/etc/systemd/resolved.conf              # conf. file
/etc/systemd/resolved.conf.d/*.conf     # drop-in conf. files
man resolved.conf                       # conf. file man-page
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

Configure a custom list of DNS resolvers:

```bash
mkdir /etc/systemd/resolved.conf.d
# use a drop in .conf file for the Quad9 primary DNS resolvers 
cat > /etc/systemd/resolved.conf.d/name_servers.conf <<EOF
[Resolve]
DNS=9.9.9.9 149.112.112.112
EOF
# if supported by the DNS resolvers, enable DNSSEC
cat > /etc/systemd/resolved.conf.d/dnssec.conf <<EOF
[Resolve]
DNSSEC=true
EOF

```
