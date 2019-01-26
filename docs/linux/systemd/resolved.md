# systemd-resolved

Provides resolver services for DNS (DNSSEC, DNS over TLS)

### Configuration

```bash
/etc/systemd/resolved.conf              # conf. file
/etc/systemd/resolved.conf.d/*.conf     # drop-in conf. files
man resolved.conf                       # conf. file man-page
```

Provides a local DNS stub listener on IP address 127.0.0.53 on the local loopback interface:

```bash
rm /etc/resolv.conf
# redirect glibc NSS conf. file to local stub DNS resolver 
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

Operations mode detected automatically depending on existence of the link above.
