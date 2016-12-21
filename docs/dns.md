
Disable DNS configuration by the NetworkManager 

```bash
>>> cat /etc/NetworkManager/NetworkManager.conf 
[Main]
dns=none
...
systemctl restart network-manager.service
```

Basic configuration...

```bash
/etc/resolv.conf             # local DNS configuration file
────────────────────────────────────────────────────────────────────────────────
nameserver 208.67.222.222    # OpenDNS
nameserver 208.67.220.220
nameserver 8.8.8.8           # Google Public DNS
nameserver 8.8.4.4
options timeout:1            # seconds before query via a different name server
```


