Disable IPv6

```bash
>>> ip addr show | grep inet6   # is it enabled?
# diable in the running kernel
>>> echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
# persistant
>>> cat /etc/sysctl.d/01-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
```
